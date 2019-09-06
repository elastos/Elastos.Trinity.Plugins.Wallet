 /*
  * Copyright (c) 2019 Elastos Foundation
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
  * in the Software without restriction, including without limitation the rights
  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  * copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be included in all
  * copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */

#import <Cordova/CDV.h>
//#import "MyUtil.h"
#import "IMasterWallet.h"
//#import "IDidManager.h"
//#import "DIDManagerSupervisor.h"
#import "MasterWalletManager.h"
#import <string.h>
#import "ELWalletManager.h"
#import "TrinityPlugin.h"


@interface Wallet : TrinityPlugin {

    ELWalletManager *walletManager;
    NSString *keySuccess;//   = "success";
    NSString *keyError;//     = "error";
    NSString *keyCode;//      = "code";
    NSString *keyMessage;//   = "message";
    NSString *keyException;// = "exception";

    int errCodeParseJsonInAction;//          = 10000;
    int errCodeInvalidArg      ;//           = 10001;
    int errCodeInvalidMasterWallet ;//       = 10002;
    int errCodeInvalidSubWallet    ;//       = 10003;
    int errCodeCreateMasterWallet  ;//       = 10004;
    int errCodeCreateSubWallet     ;//       = 10005;
    int errCodeRecoverSubWallet    ;//       = 10006;
    int errCodeInvalidMasterWalletManager;// = 10007;
    int errCodeImportFromKeyStore     ;//    = 10008;
    int errCodeImportFromMnemonic      ;//   = 10009;
    int errCodeSubWalletInstance      ;//    = 10010;
    int errCodeInvalidDIDManager      ;//    = 10011;
    int errCodeInvalidDID               ;//  = 10012;
    int errCodeActionNotFound           ;//  = 10013;

    int errCodeWalletException         ;//   = 20000;
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
- (void)print:(CDVInvokedUrlCommand*)command;
- (void)getAllMasterWallets:(CDVInvokedUrlCommand*)command;
- (void)createMasterWallet:(CDVInvokedUrlCommand*)command;
- (void)generateMnemonic:(CDVInvokedUrlCommand*)command;
- (void)createSubWallet:(CDVInvokedUrlCommand*)command;
- (void)getAllSubWallets:(CDVInvokedUrlCommand*)command;
- (void)registerWalletListener:(CDVInvokedUrlCommand*)command;
- (void)getBalance:(CDVInvokedUrlCommand *)command;
- (void)getSupportedChains:(CDVInvokedUrlCommand *)command;
- (void)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command;
- (void)getAllTransaction:(CDVInvokedUrlCommand *)command;
- (void)createAddress:(CDVInvokedUrlCommand *)command;
- (void)getGenesisAddress:(CDVInvokedUrlCommand *)command;
- (void)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (void)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (void)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)importWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (void)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command;
- (void)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command;
- (void)getAllAddress:(CDVInvokedUrlCommand *)command;
- (void)isAddressValid:(CDVInvokedUrlCommand *)command;
- (void)createDepositTransaction:(CDVInvokedUrlCommand *)command;
- (void)destroyWallet:(CDVInvokedUrlCommand *)command;
- (void)createTransaction:(CDVInvokedUrlCommand *)command;
- (void)signTransaction:(CDVInvokedUrlCommand *)command;
- (void)publishTransaction:(CDVInvokedUrlCommand *)command;
- (void)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command;
- (void)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command;
- (void)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (void)removeWalletListener:(CDVInvokedUrlCommand *)command;
- (void)createIdTransaction:(CDVInvokedUrlCommand *)command;
- (void)createDID:(CDVInvokedUrlCommand *)command;
- (void)didGenerateProgram:(CDVInvokedUrlCommand *)command;
- (void)getDIDList:(CDVInvokedUrlCommand *)command;
- (void)destoryDID:(CDVInvokedUrlCommand *)command;
- (void)didSetValue:(CDVInvokedUrlCommand *)command;
- (void)didGetValue:(CDVInvokedUrlCommand *)command;
- (void)didGetHistoryValue:(CDVInvokedUrlCommand *)command;
- (void)didGetAllKeys:(CDVInvokedUrlCommand *)command;
- (void)didSign:(CDVInvokedUrlCommand *)command;
- (void)didCheckSign:(CDVInvokedUrlCommand *)command;
- (void)didGetPublicKey:(CDVInvokedUrlCommand *)command;
- (void)registerIdListener:(CDVInvokedUrlCommand *)command;
- (void)createWithdrawTransaction:(CDVInvokedUrlCommand *)command;
- (void)getMasterWallet:(CDVInvokedUrlCommand *)command;
- (void)destroySubWallet:(CDVInvokedUrlCommand *)command;
- (void)getVersion:(CDVInvokedUrlCommand *)command;
- (void)generateProducerPayload:(CDVInvokedUrlCommand *)command;
- (void)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command;
- (void)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)getVotedProducerList:(CDVInvokedUrlCommand *)command;
- (void)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command;
- (void)getPublicKeyForVote:(CDVInvokedUrlCommand *)command;
- (void)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command;

@end

@implementation Wallet


- (CDVPluginResult *)execMethmod:(NSString *)method :(CDVInvokedUrlCommand *)command msg:(NSString *)exceptionMsg
{
    CDVPluginResult *pluginResult = nil;

    try {

        SEL selector = NSSelectorFromString(method);
        IMP imp = [walletManager methodForSelector:selector];
        CDVPluginResult* (*func)(id, SEL,CDVInvokedUrlCommand *) = (CDVPluginResult* (*)(id, SEL, CDVInvokedUrlCommand *))imp;
        pluginResult = func(walletManager,selector,command);

    }catch (Json::exception &e) {

        NSString *msg = @"json format error";
        pluginResult = [self jsonExceptionProcess:command :&e msg:msg];

    }catch (std::exception &e) {

        NSString *msg = exceptionMsg;
        pluginResult = [self exceptionProcess:command :&e msg:msg];
    }
    return pluginResult;
}
- (NSString *)formatMsg:(NSArray *)msgArray
{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i = 0; i < msgArray.count; i++) {

        NSString *str = [msgArray objectAtIndex:i];
        [string appendString:str];
    }
    NSLog(@"string  ===  %@ \n", string);
    return string;
}
- (NSString *)formatMsgWithCString:(NSString *)head string:(String)string end:(NSString *)end
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    [msgArray addObject:head];
    [msgArray addObject:[self stringWithCString:string]];
    [msgArray addObject:end];
    NSString *msg = [self formatMsg:msgArray];
    return msg;
}

- (NSString *)formatMsgWithMasterWalletIDAndChainID:(NSString *)head masterId:(String)masterWalletID chainID:(String)chainID end:(NSString *)end
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    [msgArray addObject:head];
    [msgArray addObject:[self formatWalletNameWithString:masterWalletID other:chainID]];
    [msgArray addObject:end];
    NSString *msg = [self formatMsg:msgArray];

    return msg;
}

- (NSString *)formatMsgWithMasterWalletID:(NSString *)head masterId:(String)masterWalletID end:(NSString *)end
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    [msgArray addObject:head];
    [msgArray addObject:[self formatWalletName:masterWalletID]];
    [msgArray addObject:end];
    NSString *msg = [self formatMsg:msgArray];

    return msg;
}

- (NSString *)formatWalletName:(String)stdStr
{
    NSString *string = [self stringWithCString:stdStr];
    NSString *str = [NSString stringWithFormat:@"(%@)", string];
    return str;
}
- (NSString *)formatWalletNameWithString:(String)stdStr other:(String)other
{
    NSString *string = [self stringWithCString:stdStr];
    NSString *otherString = [self stringWithCString:other];
    NSString *str = [NSString stringWithFormat:@"(%@:%@)", string, otherString];
    return str;
}

- (CDVPluginResult *)jsonExceptionProcess:(CDVInvokedUrlCommand *)command :(Json::exception *)exception  msg:(NSString *) msg
{
    CDVPluginResult* pluginResult = nil;
    String stdString(exception->what());
    NSString *jsonString = [self stringWithCString:stdString];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithLong:errCodeWalletException] forKey:keyCode];
    [dic setValue:msg forKey:keyMessage];
    [dic setValue:jsonString forKey:keyException];
    NSDictionary *jsonDic = [self mkJson:keyError value:dic];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:jsonDic];
    return pluginResult;

}
- (CDVPluginResult *)exceptionProcess:(CDVInvokedUrlCommand *)command :(std::exception *)exception  msg:(NSString *) msg
{
    CDVPluginResult* pluginResult = nil;
    NSError *error = nil;
    String stdString(exception->what());
    NSString *jsonString = [self stringWithCString:stdString];
    NSData *stringData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:&error];
    if(error)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

        [dic setValue:[NSNumber numberWithLong:errCodeWalletException] forKey:keyCode];
        [dic setValue:msg forKey:keyMessage];
        [dic setValue:jsonString forKey:keyException];
        NSDictionary *jsonDic = [self mkJson:keyError value:dic];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:jsonDic];
        return pluginResult;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    long exceptionCode = [[json objectForKey:@"Code"] longValue];
    NSString *exceptionMsg = [json objectForKey:@"Message"] ;

    [dic setValue:[NSNumber numberWithLong:exceptionCode] forKey:keyCode];
    [dic setValue:[NSString stringWithFormat:@"%@:%@", msg, exceptionMsg] forKey:keyMessage];
    id data = [json objectForKey:@"Data"];
    if(data)
    {
        int value = [data intValue];
        [dic setValue:[NSNumber numberWithInt:value] forKey:@"Data"];
    }
    NSDictionary *jsonDic = [self mkJson:keyError value:dic];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:jsonDic];
    return pluginResult;
}

- (NSString *)stringWithJson:(Json)json
{
    return [self stringWithCString:json.dump()];
}
//String 转 NSString
- (NSString *)stringWithCString:(String)string
{
    //    NSString *str = [NSString stringWithCString:string.c_str() encoding:[NSString defaultCStringEncoding]];
    NSString *str = [NSString stringWithCString:string.c_str() encoding:NSUTF8StringEncoding];
    //    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    NSString *beginStr = [str substringWithRange:NSMakeRange(0, 1)];

    NSString *result = str;
    if([beginStr isEqualToString:@"\""])
    {
        result = [str substringWithRange:NSMakeRange(1, str.length - 1)];
        //        result = [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    NSString *endStr = [result substringWithRange:NSMakeRange(result.length - 1, 1)];
    if([endStr isEqualToString:@"\""])
    {
        //        [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
        result = [result substringWithRange:NSMakeRange(0, result.length - 1)];
    }
    return result;
}
- (String)cstringWithString:(NSString *)string
{
    String  str = [string UTF8String];
    return str;
}

- (NSDictionary *)mkJson:(NSString *)key value:(id)value
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:value forKey:key];
    NSDictionary *resDic = dic;
    return resDic;

}
#pragma mark -

- (void)pluginInitialize
{

    keySuccess   = @"success";
    keyError     = @"error";
    keyCode      = @"code";
    keyMessage   = @"message";
    keyException = @"exception";

    errCodeParseJsonInAction          = 10000;
    errCodeInvalidArg                 = 10001;
    errCodeInvalidMasterWallet        = 10002;
    errCodeInvalidSubWallet           = 10003;
    errCodeCreateMasterWallet         = 10004;
    errCodeCreateSubWallet            = 10005;
    errCodeRecoverSubWallet           = 10006;
    errCodeInvalidMasterWalletManager = 10007;
    errCodeImportFromKeyStore         = 10008;
    errCodeImportFromMnemonic         = 10009;
    errCodeSubWalletInstance          = 10010;
    errCodeInvalidDIDManager          = 10011;
    errCodeInvalidDID                 = 10012;
    errCodeActionNotFound             = 10013;

    errCodeWalletException            = 30000;

    walletManager = [[ELWalletManager alloc] init];
    NSString *path = [self getConfigPath];
    path =[path stringByAppendingPathComponent:@"spv"];
    [walletManager pluginInitialize:path];
}
- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = [walletManager coolMethod:command];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)print:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = [walletManager print:command];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAllMasterWallets:(CDVInvokedUrlCommand*)command
{
    NSString *msg = @"Get all master wallets";
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)createMasterWallet:(CDVInvokedUrlCommand*)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletID:@"Create" masterId:masterWalletID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)generateMnemonic:(CDVInvokedUrlCommand*)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String language = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithCString:@"Generate mnemonic in\'" string:language end:@"\'"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)createSubWallet:(CDVInvokedUrlCommand*)command
{

    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Create " masterId:masterWalletID chainID:chainID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAllSubWallets:(CDVInvokedUrlCommand*)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Get" masterId:masterWalletID end:@"all subwallets"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)registerWalletListener:(CDVInvokedUrlCommand*)command
{
    [walletManager registerWalletListener:command :self.commandDelegate];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)getBalance:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Get" masterId:masterWalletID chainID:chainID end:@" balance info"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)getSupportedChains:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@"get support chain"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Get" masterId:masterWalletID end:@"basic info"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getAllTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Get" masterId:masterWalletID chainID:chainID end:@"all tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createAddress:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Create" masterId:masterWalletID chainID:chainID end:@" address"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getGenesisAddress:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" get genesis address"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Get" masterId:masterWalletID end:@" public key"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Export" masterId:masterWalletID end:@" to keystore"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Export" masterId:masterWalletID end:@" to mnemonic"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)changePassword:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" change password"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)importWalletWithKeystore:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID  = [self cstringWithString:args[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletID:@"Import " masterId:masterWalletID end:@" with keystore"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Import" masterId:masterWalletID end:@" with mnemonic"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command
{

    NSString *msg = @"Get multi sign public key with mnemonic";
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}

- (void)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Create multi sign" masterId:masterWalletID end:@" with mnemonic"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Create multi sign" masterId:masterWalletID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command
{

    NSString *msg = @"Get multi sign public key with private key";
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Create multi sign" masterId:masterWalletID end:@" with private key"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getAllAddress:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Get" masterId:masterWalletID chainID:chainID end:@" all addresses"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)isAddressValid:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Check address valid of " masterId:masterWalletID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create deposit tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)destroyWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Destroy " masterId:masterWalletID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Create" masterId:masterWalletID chainID:chainID end:@" tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)signTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Sign" masterId:masterWalletID chainID:chainID end:@" tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)publishTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Publish" masterId:masterWalletID chainID:chainID end:@" tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
// - (void)saveConfigs:(CDVInvokedUrlCommand *)command
// {

//     NSString *msg = @"Master wallet manager save configuration files";
//     CDVPluginResult *pluginResult = nil;
//     pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

// }

- (void)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Import " masterId:masterWalletID end:@" with old keystore"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)encodeTransactionToString:(CDVInvokedUrlCommand *)command
{

    NSString *msg = @"Encode tx to cipher string";
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)decodeTransactionFromString:(CDVInvokedUrlCommand *)command
{
    NSString *msg = @"Decode tx from cipher string";
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Get " masterId:masterWalletID chainID:chainID end:@" tx signed signers"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Get " masterId:masterWalletID chainID:chainID end:@" public key"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}


- (void)removeWalletListener:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" remove listener"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createIdTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create ID tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}


- (void)createDID:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" create DID"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didGenerateProgram:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID generate program"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getDIDList:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" get DID list"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)destoryDID:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String didName        = [self cstringWithString:args[idx++]];
    NSString *end = [NSString stringWithFormat:@" destroy DID %@", [self stringWithCString:didName]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:end];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didSetValue:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID set value"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didGetValue:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID  = [self cstringWithString:array[idx++]];
    String didName        = [self cstringWithString:array[idx++]];
    String keyPath        = [self cstringWithString:array[idx++]];

    NSString *end = [NSString stringWithFormat:@"DID get value of \'%@\'", [self stringWithCString:keyPath]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:end];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didGetHistoryValue:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID  = [self cstringWithString:array[idx++]];
    String didName        = [self cstringWithString:array[idx++]];
    String keyPath        = [self cstringWithString:array[idx++]];

    NSString *end = [NSString stringWithFormat:@"DID get history value by \'%@\'", [self stringWithCString:keyPath]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:end];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didGetAllKeys:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String didName        = [self cstringWithString:args[idx++]];
    int    start          = [args[idx++] intValue];
    int    count          = [args[idx++] intValue];

    NSString *end = [NSString stringWithFormat:@"DID get %d keys from %d", count, start];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:end];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didSign:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID sign"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didCheckSign:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID verify sign"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)didGetPublicKey:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID get public key"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}


- (void)registerIdListener:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"" masterId:masterWalletID end:@" DID register listener"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)createWithdrawTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];
    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create withdraw tx"];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getMasterWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletID:@"Get " masterId:masterWalletID end:@""];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)destroySubWallet:(CDVInvokedUrlCommand *)command
{
//    CDVPluginResult *pluginResult = [walletManager destroySubWallet:command];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"Destroy " masterId:masterWalletID chainID:chainID end:@""];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)getVersion:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)generateProducerPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" generate producer payload"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" generate cancel producer payload"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create register producer tx"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create update producer tx"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create cancel producer tx"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create retrieve deposit tx"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPublicKeyForVote:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" get public key for vote"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" create vote producer tx"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getVotedProducerList:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" get voted producer list"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;
    String masterWalletID = [self cstringWithString:array[idx++]];
    String chainID = [self cstringWithString:array[idx++]];

    NSString *msg = [self formatMsgWithMasterWalletIDAndChainID:@"" masterId:masterWalletID chainID:chainID end:@" get registerd producer info"];

    CDVPluginResult *pluginResult = nil;
    pluginResult = [self execMethmod:NSStringFromSelector(_cmd): command msg:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end
