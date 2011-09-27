//
//  JavaScriptContext.h
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

#import <Cocoa/Cocoa.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class JavaScriptContext;

@interface NSString (JavaScriptConversion)

+ (NSString *)stringWithJSString:(JSStringRef)jsStringValue;
+ (NSString *)stringWithJSValue:(JSValueRef)jsValue fromContext:(JSContextRef)ctx;

- (JSStringRef)jsStringValue;

@end

@interface JavaScriptObject : NSObject
{
    JavaScriptContext* m_context;
	JSObjectRef m_jsObject;
}

@property(readonly, retain) JavaScriptContext* context;
@property(readonly) JSObjectRef jsObject;

+ (JavaScriptObject*)javaScriptObjectWithJSObject:(JSObjectRef) obj withContext:(JavaScriptContext*) context;
+ (JavaScriptObject*)javaScriptObjectWithJSValue:(JSValueRef) value withContext:(JavaScriptContext*) context;
+ (JavaScriptObject*)createObjectWithContext:(JavaScriptContext*) context;
+ (JavaScriptObject*)createArrayWithContext:(JavaScriptContext*) context;

- (void)setStringProperty:(NSString*) property forKey:(NSString*) key;
- (void)setObjectProperty:(JavaScriptObject*) object forKey:(NSString*) key;
- (JavaScriptObject*)objectPropertyForKey:(NSString*) key;
- (NSString*)stringPropertyForKey:(NSString*) key;

@end

@interface JavaScriptContext : NSObject
{
	JSGlobalContextRef m_jsContext;
    JavaScriptObject* m_global;
}

@property(readonly,retain) JavaScriptObject* global;
@property(readonly) JSContextRef jsContext;

- (BOOL)callBooleanFunction:(NSString *) name withParameters:(id) firstParameter,...;
- (NSNumber*)callNumberFunction:(NSString *) name withParameters:(id) firstParameter,...;
- (NSString*)callStringFunction:(NSString *) name withParameters:(id) firstParameter,...;

- (void)addGlobalFunctionProperty:(NSString*) name withCallback:(JSObjectCallAsFunctionCallback) function;
- (void)addGlobalObjectProperty:(NSString*) name ofClass:(JSClassRef)clas withPrivateData:(void*) data;

- (NSString*)evaluateJavaScript:(NSString*) script;

@end
