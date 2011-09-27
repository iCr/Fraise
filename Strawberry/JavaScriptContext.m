//
//  JavascriptContext.m
//  VideoMonkey
//
//  Created by Chris Marrin on 1/9/09.

/*
Copyright (c) 2009-2011 Chris Marrin (chris@marrin.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    - Redistributions of source code must retain the above copyright notice, this 
      list of conditions and the following disclaimer.

    - Redistributions in binary form must reproduce the above copyright notice, 
      this list of conditions and the following disclaimer in the documentation 
      and/or other materials provided with the distribution.

    - Neither the name of Video Monkey nor the names of its contributors may be 
      used to endorse or promote products derived from this software without 
      specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.
*/

#import "JavascriptContext.h"

@implementation NSString (JavaScriptConversion)

+ (NSString *)stringWithJSString:(JSStringRef)jsStringValue
{
	return [ ( (NSString *) JSStringCopyCFString( kCFAllocatorDefault, jsStringValue ) ) autorelease ];
}

+ (NSString *)stringWithJSValue:(JSValueRef)jsValue fromContext:(JSContextRef)ctx
{
	NSString* result = nil;
	
	JSStringRef stringValue = JSValueToStringCopy( ctx, jsValue, nil );
	if ( stringValue != nil ) {
		result = [NSString stringWithJSString: stringValue];
		JSStringRelease(stringValue);
	}
    
	return result;
}

- (JSStringRef)jsStringValue
{
	return JSStringCreateWithCFString( (CFStringRef) self );
}

@end

@implementation JavaScriptObject

@synthesize context = m_context, jsObject = m_jsObject;

+ (JavaScriptObject*)javaScriptObjectWithJSObject:(JSObjectRef) obj withContext:(JavaScriptContext*) context
{
    JavaScriptObject* ret = [[[JavaScriptObject alloc] init] autorelease];
    ret->m_context = context;
    
    if (!obj)
        obj = JSContextGetGlobalObject([ret.context jsContext]);
        
    ret->m_jsObject = obj;
    JSValueProtect([ret.context jsContext], ret->m_jsObject);
    
    return ret;
}

+ (JavaScriptObject*)javaScriptObjectWithJSValue:(JSValueRef) value withContext:(JavaScriptContext*) context
{
    return [JavaScriptObject javaScriptObjectWithJSObject:JSValueToObject(context.jsContext, value, nil) withContext:context];
}

+ (JavaScriptObject*)createObjectWithContext:(JavaScriptContext*) context
{
    return [JavaScriptObject javaScriptObjectWithJSObject:JSObjectMake(context.jsContext, nil, nil) withContext:context];
}

+ (JavaScriptObject*)createArrayWithContext:(JavaScriptContext*) context
{
    return [JavaScriptObject javaScriptObjectWithJSObject:JSObjectMakeArray(context.jsContext, 0, nil, nil) withContext:context];
}

- (void)dealloc
{
    JSValueUnprotect([m_context jsContext], m_jsObject);
    [super dealloc];
}

-(JSValueRef) jsValuePropertyForKey:(NSString*) key
{
	JSStringRef jskey = [key jsStringValue];
    JSValueRef error = JSValueMakeNull(self.context.jsContext);
    
    JSValueRef jsValue = JSObjectGetProperty(self.context.jsContext, self.jsObject, jskey, &error);

    if (!JSValueIsNull(self.context.jsContext, error)) {
        // FIXME: deal with reporting errors
        //if (showError) {
        //    NSString* errorString = [NSString stringWithJSValue: error fromContext: m_jsContext];
        //    NSRunAlertPanel(@"JavaScript error in property get", errorString, nil, nil, nil);
        //}
        jsValue = JSValueMakeUndefined(self.context.jsContext);
    }
    else if (JSValueIsUndefined(self.context.jsContext, jsValue)) {
        //if (showError) {
        //    NSRunAlertPanel(@"JavaScript error in property get", [NSString stringWithFormat:@"Property '%@' does not exist", key], nil, nil, nil);
        //    jsValue = JSValueMakeUndefined(m_jsContext);
        //}
    }

    JSStringRelease(jskey);
    return jsValue;
}

-(BOOL) jsHasValuePropertyForKey:(NSString*) key
{
	JSStringRef jskey = [key jsStringValue];    
    BOOL result = JSObjectHasProperty(self.context.jsContext, self.jsObject, jskey);
    JSStringRelease(jskey);
    return result;
}

-(void) setJSValueProperty:(JSValueRef) jsValue forKey:(NSString*) key
{
	JSStringRef propertyName = [key jsStringValue];
	if (propertyName != nil) {
        JSObjectSetProperty(self.context.jsContext, self.jsObject, propertyName, jsValue, kJSPropertyAttributeNone, nil);        
		JSStringRelease(propertyName);
	}
}

- (void)setStringProperty:(NSString*) property forKey:(NSString*) key
{
    JSStringRef propertyValue = [property jsStringValue];
    if (propertyValue != nil) {
        JSValueRef valueInContext = JSValueMakeString(self.context.jsContext, propertyValue);
        if (valueInContext != nil)
            [self setJSValueProperty: valueInContext forKey: key];
        JSStringRelease(propertyValue);
	}
}

- (void)setObjectProperty:(JavaScriptObject*) object forKey:(NSString*) key
{
    [self setJSValueProperty:object.jsObject forKey: key];
}

- (JavaScriptObject*)objectPropertyForKey:(NSString*) key
{
    JSValueRef jsValue = [self jsValuePropertyForKey:key];
    if (JSValueIsUndefined(self.context.jsContext, jsValue))
        return nil;
    return [JavaScriptObject javaScriptObjectWithJSObject:JSValueToObject(self.context.jsContext, jsValue, nil) withContext:self.context];
}

- (NSString*)stringPropertyForKey:(NSString*) key
{
    JSValueRef jsValue = [self jsValuePropertyForKey:key];
    if (JSValueIsUndefined(self.context.jsContext, jsValue))
        return nil;
        
    JSStringRef jsstring = JSValueToStringCopy(self.context.jsContext, jsValue, nil);
    NSString* string = [[NSString stringWithJSString:jsstring] retain];
    JSStringRelease(jsstring);
    return string;
}

@end

@implementation JavaScriptContext

@synthesize global = m_global, jsContext = m_jsContext;

- (id)init
{
	if ((self = [super init]) != nil) {
		m_jsContext = JSGlobalContextCreate(nil);
        
        m_global = [[JavaScriptObject javaScriptObjectWithJSObject: JSContextGetGlobalObject(m_jsContext) withContext:self] retain];
    
        // add param object
        [self evaluateJavaScript:@"params = { }"];
    }
	return self;
}

- (void)dealloc
{
    if (m_jsContext)
        JSGlobalContextRelease(m_jsContext);
    m_jsContext = nil;
    [m_global release];
	[super dealloc];
}

-(void) showSyntaxError:(JSValueRef) error forScript:(NSString*) script
{
    if (!JSValueIsNull(m_jsContext, error)) {
        JavaScriptObject* obj = [JavaScriptObject javaScriptObjectWithJSValue:error withContext:self];
		JSValueRef line = JSObjectGetProperty(m_jsContext, [obj jsObject], [@"line" jsStringValue], nil);
        double lineNumber = JSValueToNumber(m_jsContext, line, nil);
        NSString* errorString = [NSString stringWithJSValue: error fromContext: m_jsContext];
        
        NSString* snippet = script;
        int length = 80;
        if ([script length] > length)
            snippet = [script substringToIndex:length];
        
        NSString* alertString = [NSString stringWithFormat: @"%@ at line %d\n\nWhile parsing script starting with:\n\n%@", errorString, (int) lineNumber, snippet];
        NSRunAlertPanel(@"JavaScript error in evaluation", alertString, nil, nil, nil);
    }
}

// -vsCallJSFunction:withParameters: is much like the vsprintf function in that
// it receives a va_list rather than a variable length argument list.  This
// is a simple utility for calling JavaScript functions in a JavaScriptContext
// that is called by the other call*JSFunction methods in this file to do the
// actual work.  The caller provides a function name and the parameter va_list,
// and -vsCallJSFunction:withParameters: uses those to call the function in the
// JavaScriptCore context.  Only NSString and NSNumber values can be provided
// as parameters.  The result returned is the same as the value returned by
// the function,  or nil if an error occured.

- (JSValueRef)vsCallJSFunction:(NSString *)name withArg:(id)firstParameter andArgList:(va_list)args
{
	JSValueRef result = nil;
    
    JavaScriptObject* function = [self.global objectPropertyForKey:name];
	
    // Verify that it's a function
    if (function && JSValueIsObject(self.jsContext, function.jsObject)) {
        const size_t kMaxArgCount = 20;
        id arg;
        BOOL argsOK = YES;
        size_t argumentCount = 0;
        JSValueRef arguments[kMaxArgCount];
        
        JSObjectRef jsFunction = function.jsObject;
            
        for (arg = firstParameter; argsOK && arg && argumentCount < kMaxArgCount; arg = va_arg(args, id)) {
            if ( [arg isKindOfClass:[NSNumber class]] )
                arguments[argumentCount++] = JSValueMakeNumber(m_jsContext, [arg doubleValue]);
            else if ([arg isKindOfClass:[NSString class]]) {
                JSStringRef argString = [arg jsStringValue];
                if (argString) {
                    arguments[argumentCount++] = JSValueMakeString(m_jsContext, argString);
                    JSStringRelease(argString);
                } else
                    argsOK = NO;
            } else {
                NSLog(@"bad parameter type for item %lu (%@) in vsCallJSFunction:withArg:andArgList:", argumentCount, arg);
                argsOK = NO;
            }
        }

        if ( argsOK )
            result = JSObjectCallAsFunction(m_jsContext, jsFunction, nil, argumentCount, arguments, nil);
    }
            
	return result;
}

- (JSValueRef)callJSFunction:(NSString *)name withParameters:(id)firstParameter, ...
{
	JSValueRef result = nil;
	va_list args;

	va_start(args, firstParameter);
	result = [self vsCallJSFunction: name withArg: firstParameter andArgList: args];
	va_end( args );

	return result;
}

- (BOOL)callBooleanFunction:(NSString *)name withParameters:(id)firstParameter, ...
{
	BOOL result;
	va_list args;

	va_start(args, firstParameter);
	JSValueRef functionResult = [self vsCallJSFunction: name withArg: firstParameter andArgList: args];
	va_end(args);

	if (functionResult && JSValueIsBoolean(m_jsContext, functionResult))
		 result = (JSValueToBoolean(m_jsContext, functionResult) ? YES : NO);
	else
		result = NO;
        
	return result;
}

- (NSNumber *)callNumberFunction:(NSString*)name withParameters:(id)firstParameter, ...
{
	NSNumber* result;
	va_list args;

	va_start(args, firstParameter);
	JSValueRef functionResult = [self vsCallJSFunction: name withArg: firstParameter andArgList: args];
	va_end(args);

	if (functionResult && JSValueIsNumber(m_jsContext, functionResult))
		 result = [NSNumber numberWithDouble: JSValueToNumber(m_jsContext, functionResult, nil)];
	else
		result = nil;
        
	return result;
}

- (NSString *)callStringFunction:(NSString *)name withParameters:(id)firstParameter, ...
{
	NSString* result = nil;
	va_list args;

	va_start(args, firstParameter);
	JSValueRef functionResult = [self vsCallJSFunction: name withArg: firstParameter andArgList: args];
	va_end(args);

	if (functionResult)
        result = [NSString stringWithJSValue:functionResult fromContext: m_jsContext];
	
	return result;
}

- (void)addGlobalObjectProperty:(NSString*) name ofClass:(JSClassRef)clas withPrivateData:(void *)data
{
    if (!clas) {
        JSClassDefinition definition = kJSClassDefinitionEmpty;
        clas = JSClassCreate(&definition);
    }

	JSObjectRef object = JSObjectMake(m_jsContext, clas, data);
	if (object) {
        JSValueProtect(m_jsContext, object);
        JSStringRef objectJSName = [name jsStringValue];
		if (objectJSName) {
            JSObjectSetProperty(m_jsContext, self.global.jsObject, objectJSName, object, kJSPropertyAttributeReadOnly, nil);
            JSStringRelease(objectJSName);
		}
	}
}

- (void)addGlobalFunctionProperty:(NSString *) name withCallback:(JSObjectCallAsFunctionCallback) function
{
	JSStringRef functionName = [name jsStringValue];
	if (functionName) {
		JSObjectRef functionObject = JSObjectMakeFunctionWithCallback(m_jsContext, functionName, function);
        
		if (functionObject)
			JSObjectSetProperty( m_jsContext, self.global.jsObject, functionName, functionObject, kJSPropertyAttributeReadOnly, nil);

		JSStringRelease(functionName);
	}
}

- (NSString*)evaluateJavaScript:(NSString *) script
{
	NSString* resultString = nil;
	
	JSStringRef scriptJS = [script jsStringValue];
	if (scriptJS) {
        JSValueRef error = JSValueMakeNull(m_jsContext);
		JSValueRef result = JSEvaluateScript(m_jsContext, scriptJS, nil, [@"MyScript" jsStringValue], 0, &error);
        
        if (!JSValueIsNull(m_jsContext, error))
            [self showSyntaxError: error forScript:(NSString*) script];
        else if (result)
			resultString = [NSString stringWithJSValue:result fromContext: m_jsContext];

		JSStringRelease(scriptJS);
	}
	return resultString;
}

@end
