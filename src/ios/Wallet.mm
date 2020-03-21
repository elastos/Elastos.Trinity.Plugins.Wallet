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

#import "Wallet.h"
#import <Cordova/CDVCommandDelegate.h>
#import "WrapSwift.h"

#pragma mark - ElISubWalletCallback C++

using namespace Elastos::ElaWallet;
class ElISubWalletCallback: public ISubWalletCallback
{
public:
    ElISubWalletCallback( id <CDVCommandDelegate> delegate, String &masterWalletID,
                         String &chainID, CDVInvokedUrlCommand *command);

    ~ElISubWalletCallback();

    CDVPluginResult *successAsDict(CDVInvokedUrlCommand *command, NSDictionary* dict);
    CDVPluginResult *successAsString(CDVInvokedUrlCommand *command, NSString* str);
    CDVPluginResult *errorProcess(CDVInvokedUrlCommand *command, int code, id msg);

    void OnTransactionStatusChanged(const std::string &txid, const std::string &status, const nlohmann::json &desc, uint32_t confirms);
    void OnBalanceChanged(const std::string &asset, const std::string & balance);
    void OnBlockSyncProgress(const nlohmann::json &progressInfo);
    void OnTxPublished(const std::string &hash, const nlohmann::json &result);
    void OnAssetRegistered(const std::string &asset, const nlohmann::json &info);
    void OnConnectStatusChanged(const std::string &status);

private:
    id <CDVCommandDelegate> commandDelegate;
    NSString * mMasterWalletID;
    NSString * mSubWalletID;
    CDVInvokedUrlCommand *mCommand;
    NSString *keySuccess;//   = @"success";
    NSString *keyError;//     = "error";
    NSString *keyCode;//      = "code";
    NSString *keyMessage;//   = "message";
    NSString *keyException;// = "exception";
};
ElISubWalletCallback::ElISubWalletCallback(id <CDVCommandDelegate> delegate, String &masterWalletID,
                                           String &chainID, CDVInvokedUrlCommand *command)
{
    mMasterWalletID = [NSString stringWithCString:masterWalletID.c_str() encoding:NSUTF8StringEncoding];
    mSubWalletID = [NSString stringWithCString:chainID.c_str() encoding:NSUTF8StringEncoding];
    commandDelegate = delegate;
    mCommand = command;

    keySuccess   = @"success";
    keyError     = @"error";
    keyCode      = @"code";
    keyMessage   = @"message";
    keyException = @"exception";
}
ElISubWalletCallback::~ElISubWalletCallback()
{
}

CDVPluginResult *ElISubWalletCallback::successAsDict(CDVInvokedUrlCommand *command, NSDictionary* dict)
{
    [dict setValue:mMasterWalletID forKey:@"MasterWalletID"];
    [dict setValue:mSubWalletID forKey:@"ChainID"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    return pluginResult;
}

CDVPluginResult *ElISubWalletCallback::successAsString(CDVInvokedUrlCommand *command, NSString* str)
{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    return pluginResult;
}

CDVPluginResult *ElISubWalletCallback::errorProcess(CDVInvokedUrlCommand *command, int code, id msg)
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInteger:code] forKey:keyCode];
    [dict setValue:msg forKey:keyMessage];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary: dict];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    return pluginResult;
}

void ElISubWalletCallback::OnTransactionStatusChanged(const std::string &txid,
                        const std::string &status, const nlohmann::json &desc, uint32_t confirms)
{
    NSLog(@" ----OnTransactionStatusChanged ----\n");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *txIdStr = [NSString stringWithCString:txid.c_str() encoding:NSUTF8StringEncoding];
    NSString *statusStr = [NSString stringWithCString:status.c_str() encoding:NSUTF8StringEncoding];
    NSString *descStr = [NSString stringWithCString:desc.dump().c_str() encoding:NSUTF8StringEncoding];
    NSNumber *confirmNum = [NSNumber numberWithInt:confirms];

    [dict setValue:txIdStr forKey:@"txId"];
    [dict setValue:statusStr forKey:@"status"];
    [dict setValue:descStr forKey:@"desc"];
    [dict setValue:confirmNum forKey:@"confirms"];
    [dict setValue:@"OnTransactionStatusChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

void ElISubWalletCallback::OnBlockSyncProgress(const nlohmann::json &progressInfo)
{
    NSLog(@" ----OnBlockSyncProgress ----\n");

    NSString *progressInfoString = [NSString stringWithCString:progressInfo.dump().c_str() encoding:NSUTF8StringEncoding];

    NSError *err;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[progressInfoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    [dict setValue:@"OnBlockSyncProgress" forKey:@"Action"];
    CDVPluginResult* pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

void ElISubWalletCallback::OnBalanceChanged(const std::string &asset, const std::string &balance)
{
    NSLog(@" ----OnBalanceChanged ----\n");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSString *assetString = [NSString stringWithCString:asset.c_str() encoding:NSUTF8StringEncoding];
    NSString *balanceString = [NSString stringWithCString:balance.c_str() encoding:NSUTF8StringEncoding];

    [dict setValue:assetString forKey:@"Asset"];
    [dict setValue:balanceString forKey:@"Balance"];
    [dict setValue:@"OnBalanceChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

void ElISubWalletCallback::OnTxPublished(const std::string &hash, const nlohmann::json &result)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSString *hashString = [NSString stringWithCString:hash.c_str() encoding:NSUTF8StringEncoding];
    NSString *resultString = [NSString stringWithCString:result.dump().c_str() encoding:NSUTF8StringEncoding];

    [dict setValue:hashString forKey:@"hash"];
    [dict setValue:resultString forKey:@"result"];
    [dict setValue:@"OnTxPublished" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

void ElISubWalletCallback::OnAssetRegistered(const std::string &asset, const nlohmann::json &info)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSString *assetString = [NSString stringWithCString:asset.c_str() encoding:NSUTF8StringEncoding];
    NSString *infoString = [NSString stringWithCString:info.dump().c_str() encoding:NSUTF8StringEncoding];

    [dict setValue:assetString forKey:@"asset"];
    [dict setValue:infoString forKey:@"info"];
    [dict setValue:@"OnAssetRegistered" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

void ElISubWalletCallback::OnConnectStatusChanged(const std::string &status)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *statusString = [NSString stringWithCString:status.c_str() encoding:NSUTF8StringEncoding];

    [dict setValue:statusString forKey:@"status"];
    [dict setValue:@"OnConnectStatusChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDict(mCommand, dict);

    [commandDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

#pragma mark - Wallet

@interface Wallet ()
{
    //    ELIIdManagerCallback *iidCallback;
}

@end


@implementation Wallet

#pragma mark -
- (IMasterWallet *)getIMasterWallet:(String)masterWalletID
{
    if (mMasterWalletManager == nil) {
        return nil;
    }
    return mMasterWalletManager->GetMasterWallet(masterWalletID);
}

- (ISubWallet *)getSubWallet:(String)masterWalletID :(String)chainID
{
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        return nil;
    }
    ISubWalletVector subWalletList = masterWallet->GetAllSubWallets();
    for (int i = 0; i < subWalletList.size(); i++) {
        ISubWallet *iSubWallet = subWalletList[i];
        NSString *getChainIDString = [self stringWithCString:iSubWallet->GetChainID()];
        NSString *chainIDString = [self stringWithCString:chainID];

        if ([chainIDString isEqualToString:getChainIDString]) {
            return iSubWallet;
        }
    }
    return nil;
}

#pragma mark -

- (NSString *)getBasicInfo:(IMasterWallet *)masterWallet
{
    Json json = masterWallet->GetBasicInfo();
    NSString *jsonString = [self stringWithCString:json.dump()];
    return jsonString;
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

- (void)errCodeInvalidArg:(CDVInvokedUrlCommand *)command code:(int)code idx:(int)idx
{
    NSString *msg = [NSString stringWithFormat:@"%d %@", idx, @" parameters are expected"];
    return [self errorProcess:command code:code msg:msg];
}

- (void)successAsDict:(CDVInvokedUrlCommand *)command  msg:(NSDictionary*) dict
{
    CDVPluginResult*  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)successAsString:(CDVInvokedUrlCommand *)command  msg:(NSString*) msg
{
    CDVPluginResult*  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)errorProcess:(CDVInvokedUrlCommand *)command  code : (int) code msg:(id) msg
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInteger:code] forKey:keyCode];
    [dict setValue:msg forKey:keyMessage];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (NSDictionary *)parseOneParam:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:value forKey:key];
    return dict;
}

- (NSString *)dictToJSONString:(NSDictionary *)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                    options:kNilOptions
                                                     error:nil];

    if (data == nil) {
        return nil;
    }

    NSString *string = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
    return string;
}
- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                    options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                    error:nil];

    if (data == nil) {
        return nil;
    }

    NSString *string = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
    return string;
}
#pragma mark - String Json NSString

- (Json)jsonWithString:(NSString *)string
{
    String std = [self cstringWithString:string];
    Json json = Json::parse(std);
    return json;
}

- (Json)jsonWithDict:(NSDictionary *)dict
{
    NSString *string = [self dictToJSONString:dict];
    String std = [self cstringWithString:string];
    Json json = Json::parse(std);
    return json;
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

#pragma mark - plugin

- (void)applicationEnterBackground
{
    // if (mMasterWalletManager != nil) {
    //     mMasterWalletManager->SaveConfigs();
    // }
}
- (void)applicationBecomeActive
{

}

- (void)pluginInitialize
{
    // app启动或者app从后台进入前台都会调用这个方法
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillTerminateNotification) name: UIApplicationWillTerminateNotification object:nil];


    //    ISubWalletVector = new  ISubWalletVector();
    //    ISubWalletArray = [[NSMutableArray alloc] init];
    //    ISubWalletCallBackArray = [[NSMutableArray alloc] init];
    //
    TAG = @"Wallet";

    mMasterWalletManager = NULL;
    mRootPath = NULL;

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
    errCodeActionNotFound             = 10013;

    errCodeWalletException            = 20000;


    NSString* rootPath = [[self getDataPath] stringByAppendingString:@"spv"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:rootPath]) {
        [fm createDirectoryAtPath:rootPath withIntermediateDirectories:true attributes:NULL error:NULL];
    }

    NSString* dataPath = [rootPath stringByAppendingString:@"/data"];
    if (![fm fileExistsAtPath:dataPath]) {
        [fm createDirectoryAtPath:dataPath withIntermediateDirectories:true attributes:NULL error:NULL];
    }
    NSString* netType = [WrapSwift getWalletNetworkType];
    NSString* config = [WrapSwift getWalletNetworkConfig];
    mMasterWalletManager = new MasterWalletManager([rootPath UTF8String], [netType UTF8String]
            , [config UTF8String], [dataPath UTF8String]);

    [super pluginInitialize];
}
- (void)coolMethod:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)print:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    NSString *text = [command.arguments objectAtIndex:0];

    if(!text || ![text isEqualToString:@""]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self parseOneParam:@"text" value:text]];
    }
    else {
        NSString *error = @"Text not can be null";
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAllMasterWallets:(CDVInvokedUrlCommand *)command
{
    IMasterWalletVector vector = mMasterWalletManager->GetAllMasterWallets();
    //    NSArray *masterWalletList = MyGetArrayFromVector(vector,Elastos::ElaWallet::IMasterWallet);
    NSMutableArray *masterWalletListJson = [[NSMutableArray alloc] init];
    for (int i = 0; i < vector.size(); i++) {
        IMasterWallet *iMasterWallet = vector[i];
        String idStr = iMasterWallet->GetID();
        NSString *str = [self stringWithCString:idStr];
        [masterWalletListJson addObject:str];
    }
    NSString *jsonString = [self arrayToJSONString:masterWalletListJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createMasterWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;

    String masterWalletID = [self cstringWithString:[array objectAtIndex:idx++]];
    String mnemonic       = [self cstringWithString:[array objectAtIndex:idx++]];;
    String phrasePassword = [self cstringWithString:[array objectAtIndex:idx++]];;
    String payPassword    = [self cstringWithString:[array objectAtIndex:idx++]];
    Boolean singleAddress = [[array objectAtIndex:idx++] boolValue];

    NSArray *args = command.arguments;
    if (args.count != idx) {        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->CreateMasterWallet(
            masterWalletID, mnemonic, phrasePassword, payPassword, singleAddress);

    if (masterWallet == NULL) {
        NSString *msg = [NSString stringWithFormat:@"Create %@", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }

    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)generateMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    NSString *language = args[idx++];
    //
    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }
    String mnemonic = mMasterWalletManager->GenerateMnemonic([self cstringWithString:language]);
    NSString *mnemonicString = [self stringWithCString:mnemonic];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mnemonicString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
- (void)createSubWallet:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    ISubWallet *subWallet = masterWallet->CreateSubWallet(chainID);
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Create", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeCreateSubWallet msg:msg];
    }
    Json json = subWallet->GetBasicInfo();
    NSString *jsonString = [self stringWithCString:json.dump()];

    return [self successAsString:command msg:jsonString];

}
- (void)getAllSubWallets:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    NSMutableArray *subWalletJsonArray = [[NSMutableArray alloc] init];
    ISubWalletVector subWalletList = masterWallet->GetAllSubWallets();
    for (int i = 0; i < subWalletList.size(); i++) {
        ISubWallet *iSubWallet = subWalletList[i];
        String chainId = iSubWallet->GetChainID();
        NSString *chainIdString = [self stringWithCString:chainId];
        [subWalletJsonArray addObject:chainIdString];
    }
    NSString *msg = [self arrayToJSONString:subWalletJsonArray];
    return [self successAsString:command msg:msg];
}

- (void)registerWalletListener:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    ElISubWalletCallback *subCallback =  new ElISubWalletCallback(self.commandDelegate, masterWalletID, chainID, command);
    subWallet->AddCallback(subCallback);
}

- (void)getBalance:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    String balance = subWallet->GetBalance();
    NSString *balanceStr = [self stringWithCString:balance];

    return [self successAsString:command msg:balanceStr];
}

- (void)getBalanceInfo:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = subWallet->GetBalanceInfo();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getSupportedChains:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    StringVector stringVec = masterWallet->GetSupportedChains();
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < stringVec.size(); i++) {
        String string = stringVec[i];
        NSString *sstring = [self stringWithCString:string];
        [stringArray addObject:sstring];
    }

    CDVPluginResult*  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:stringArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)getAllTransaction:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    int    start          = [args[idx++] intValue];
    int    count          = [args[idx++] intValue];
    String addressOrTxId  = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID : chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = subWallet->GetAllTransaction(start, count, addressOrTxId);
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];

}
- (void)createAddress:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    String address = subWallet->CreateAddress();
    NSString *jsonString = [self stringWithCString:address];
    return [self successAsString:command msg:jsonString];
}

- (void)getGenesisAddress:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    ISidechainSubWallet *sidechainSubWallet = dynamic_cast<ISidechainSubWallet *>(subWallet);
    if(sidechainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of ISidechainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String address = sidechainSubWallet->GetGenesisAddress();
    NSString *jsonString = [self stringWithCString:address];
    return [self successAsString:command msg:jsonString];
}

// - (void)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command
// {
//     NSArray *args = command.arguments;
//     int idx = 0;

//     String masterWalletID = [self cstringWithString:args[idx++]];;

//     if (args.count != idx) {

//         return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//     }
//     IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
//     if (masterWallet == nil) {
//         NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
//         return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
//     }
//     Json json = masterWallet->GetPublicKey();
//     NSString *jsonString = [self stringWithCString:json.dump()];
//     return [self successAsString:command msg:jsonString];
// }

- (void)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String backupPassword = [self cstringWithString:args[idx++]];
    String payPassword = [self cstringWithString:args[idx++]];
    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    Json json = masterWallet->ExportKeystore(backupPassword, payPassword);
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];
}

- (void)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String backupPassword = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    Json json = masterWallet->ExportMnemonic(backupPassword);

    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];
}

- (void)changePassword:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String oldPassword = [self cstringWithString:args[idx++]];
    String newPassword = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    masterWallet->ChangePassword(oldPassword, newPassword);
    return [self successAsString:command msg:@"Change password OK"];
}

- (void)importWalletWithKeystore:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    Json keystoreContent = [self jsonWithString:args[idx++]];
    String backupPassword = [self cstringWithString:args[idx++]];
    String payPassword = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->ImportWalletWithKeystore(
                                                                                 masterWalletID, keystoreContent, backupPassword, payPassword);

    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Import", [self formatWalletName:masterWalletID], @"with keystore"];
        return [self errorProcess:command code:errCodeImportFromKeyStore msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String mnemonic       = [self cstringWithString:args[idx++]];
    String phrasePassword = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];
    Boolean singleAddress =  [args[idx++] boolValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = mMasterWalletManager->ImportWalletWithMnemonic(
                                                                                 masterWalletID, mnemonic, phrasePassword, payPassword, singleAddress);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Import", [self formatWalletName:masterWalletID], @"with mnemonic"];
        return [self errorProcess:command code:errCodeImportFromMnemonic msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

// - (void)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command
// {
//     NSArray *args = command.arguments;
//     int idx = 0;

//     String mnemonic = [self cstringWithString:args[idx++]];
//     String phrasePassword = [self cstringWithString:args[idx++]];

//     if (args.count != idx) {

//         return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//     }
//     if (mMasterWalletManager == nil) {
//         NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
//         return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
//     }

//     String pubKey = mMasterWalletManager->GetMultiSignPubKey(mnemonic, phrasePassword);

//     NSString *jsonString = [self stringWithCString:pubKey];
//     return [self successAsString:command msg:jsonString];
// }

- (void)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String mnemonic       = [self cstringWithString:args[idx++]];
    String phrasePassword = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];
    String str            = [self cstringWithString:args[idx++]];
    Json publicKeys       = Json::parse(str);
    int m                 = [args[idx++] intValue];
    long timestamp        = [args[idx++] longValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->CreateMultiSignMasterWallet(
                                                                                    masterWalletID, mnemonic, phrasePassword, payPassword, publicKeys, m, timestamp);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Create multi sign", [self formatWalletName:masterWalletID], @"with mnemonic"];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String str = [self cstringWithString:args[idx++]];
    Json publicKeys = Json::parse(str);
    int m = [args[idx++] intValue];
    long timestamp = [args[idx++] longValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->CreateMultiSignMasterWallet(
                                        masterWalletID, publicKeys, m, timestamp);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Create multi sign", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

// - (void)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command
// {
//     NSArray *args = command.arguments;
//     int idx = 0;

//     String privKey = [self cstringWithString:args[idx++]];

//     if (args.count != idx) {
//         return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//     }
//     if (mMasterWalletManager == nil) {
//         NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
//         return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
//     }

//     String privateKey = mMasterWalletManager->GetMultiSignPubKey(privKey);
//     NSString *jsonString = [self stringWithCString:privateKey];
//     return [self successAsString:command msg:jsonString];
// }

- (void)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String privKey        = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];
    String str            = [self cstringWithString:args[idx++]];
    Json publicKeys       = Json::parse(str);
    int m                 = [args[idx++] intValue];
    long timestamp        = [args[idx++] longValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->CreateMultiSignMasterWallet(
                                                                                    masterWalletID, privKey, payPassword, publicKeys, m, timestamp);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Create multi sign", [self formatWalletName:masterWalletID], @"with private key"];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)getAllAddress:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    int start             = [args[idx++] intValue];
    int count             = [args[idx++] intValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = subWallet->GetAllAddress(start, count);
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];
}

- (void)isAddressValid:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String addr       = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    Boolean valid = masterWallet->IsAddressValid(addr);
    CDVPluginResult*  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:valid];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID    = [self cstringWithString:args[idx++]];
    String chainID           = [self cstringWithString:args[idx++]];
    String fromAddress       = [self cstringWithString:args[idx++]];
    String lockedAddress     = [self cstringWithString:args[idx++]];
    String amount            = [self cstringWithString:args[idx++]];
    String sideChainAddress  = [self cstringWithString:args[idx++]];
    String memo              = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->CreateDepositTransaction(fromAddress, lockedAddress, amount, sideChainAddress, memo);
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];
}

- (void)destroyWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    ISubWalletVector subWallets = masterWallet->GetAllSubWallets();
    for (int i = 0; i < subWallets.size(); i++) {
        subWallets[i]->RemoveCallback();
    }

    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }
    mMasterWalletManager->DestroyWallet(masterWalletID);
    NSString *msg = [NSString stringWithFormat:@"Destroy %@ OK", [self formatWalletName:masterWalletID]];
    return [self successAsString:command msg:msg];
}

- (void)createTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    String toAddress      = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = subWallet->CreateTransaction(fromAddress, toAddress, amount, memo);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)createConsolidateTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json result = subWallet->CreateConsolidateTransaction(memo);
    NSString *msg = [self stringWithJson:result];
    return [self successAsString:command msg:msg];
}

- (void)signTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json rawTransaction   = [self jsonWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json result = subWallet->SignTransaction(rawTransaction, payPassword);
    NSString *msg = [self stringWithJson:result];
    return [self successAsString:command msg:msg];
}

- (void)publishTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json rawTxJson        =  [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json result = subWallet->PublishTransaction(rawTxJson);
    NSString *msg = [self stringWithJson:result];
    return [self successAsString:command msg:msg];
}

// - (void)saveConfigs:(CDVInvokedUrlCommand *)command
// {
//     if(mMasterWalletManager)
//     {
//         mMasterWalletManager->SaveConfigs();
//     }
//     NSString *msg = @"Configuration files save successfully";
//     return [self successAsString:command msg:msg];
// }

// - (void)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command
// {
//     NSArray *args = command.arguments;
//     int idx = 0;

//     String masterWalletID  = [self cstringWithString:args[idx++]];
//     String keystoreContent = [self cstringWithString:args[idx++]];
//     String backupPassword  = [self cstringWithString:args[idx++]];
//     String payPassword     = [self cstringWithString:args[idx++]];
//     String phrasePassword  = [self cstringWithString:args[idx++]];

//     if (args.count != idx) {
//         return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//     }
//     IMasterWallet *masterWallet = mMasterWalletManager->ImportWalletWithKeystore(         masterWalletID, keystoreContent, backupPassword, payPassword);
//     if (masterWallet == nil) {
//         NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Import", [self formatWalletName:masterWalletID], @"with keystore"];
//         return [self errorProcess:command code:errCodeImportFromKeyStore msg:msg];
//     }
//     NSString *jsonString = [self getBasicInfo:masterWallet];
//     return [self successAsString:command msg:jsonString];
// }

- (void)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json rawTxJson        = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    Json resultJson = subWallet->GetTransactionSignedInfo(rawTxJson);
    NSString *jsonString = [self stringWithJson:resultJson];
    return [self successAsString:command msg:jsonString];
}

// - (void)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command
// {
//     NSArray *args = command.arguments;
//     int idx = 0;

//     String masterWalletID = [self cstringWithString:args[idx++]];
//     String chainID       = [self cstringWithString:args[idx++]];

//     if (args.count != idx) {
//         return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//     }

//     ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
//     if (subWallet == nil) {
//         NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
//         return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
//     }
//     String str = subWallet->GetPublicKey();
//     NSString *msg = [self stringWithCString:str];
//     return [self successAsString:command msg:msg];
// }

- (void)removeWalletListener:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    subWallet->RemoveCallback();

    NSString *msg = [NSString stringWithFormat:@"%@ %@", @"remove listener", [self formatWalletNameWithString:masterWalletID other:chainID]];
    return [self successAsString:command msg:msg];
}

- (void)createIdTransaction:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithDict:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IIDChainSubWallet *idchainSubWallet = dynamic_cast<IIDChainSubWallet *>(subWallet);
    if(idchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"is not instance of IIDChainSubWallet", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json json = idchainSubWallet->CreateIDTransaction(payloadJson, memo);
    NSString *msg = [self stringWithJson:json];
    return [self successAsString:command msg:msg];
}

- (void)createWithdrawTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String mainchainAddress  = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    ISidechainSubWallet *sidechainSubWallet = dynamic_cast<ISidechainSubWallet *>(subWallet);
    if(sidechainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of ISidechainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = sidechainSubWallet->CreateWithdrawTransaction(fromAddress, amount, mainchainAddress, memo);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getMasterWallet:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (void)destroySubWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    masterWallet->DestroyWallet(chainID);
    subWallet->RemoveCallback();

    NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Destroy", [self formatWalletNameWithString:masterWalletID other:chainID]];
    return [self successAsString:command msg:msg];
}

- (void)getVersion:(CDVInvokedUrlCommand *)command
{
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }
    String version = mMasterWalletManager->GetVersion();
    NSString *msg = [self stringWithCString:version];
    return [self successAsString:command msg:msg];
}

- (void)generateProducerPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String publicKey      = [self cstringWithString:args[idx++]];
    String nodePublicKey  = [self cstringWithString:args[idx++]];
    String nickName       = [self cstringWithString:args[idx++]];
    String url            = [self cstringWithString:args[idx++]];
    String IPAddress      = [self cstringWithString:args[idx++]];
    long   location       = [args[idx++] longValue];
    String payPasswd      = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json payloadJson = mainchainSubWallet->GenerateProducerPayload(publicKey, nodePublicKey, nickName, url, IPAddress, location, payPasswd);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (void)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String publicKey      = [self cstringWithString:args[idx++]];
    String payPasswd      = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String payloadJson = mainchainSubWallet->GenerateCancelProducerPayload(publicKey, payPasswd);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateRegisterProducerTransaction(fromAddress, payloadJson, amount, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateUpdateProducerTransaction(fromAddress, payloadJson, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateCancelProducerTransaction(fromAddress, payloadJson, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateRetrieveDepositTransaction(amount, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)getPublicKeyForVote:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String msg = mainchainSubWallet->GetOwnerPublicKey();
    NSString *jsonString = [self stringWithCString:msg];
    return [self successAsString:command msg:jsonString];
}

- (void)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String chainID         = [self cstringWithString:args[idx++]];
    String fromAddress     = [self cstringWithString:args[idx++]];
    String stake           = [self cstringWithString:args[idx++]];
    Json publicKeys        = [self jsonWithString:args[idx++]];
    String memo            = [self cstringWithString:args[idx++]];
    Json invalidCandidates = Json::parse("[]");

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateVoteProducerTransaction(fromAddress, stake, publicKeys, memo, invalidCandidates);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)getVotedProducerList:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetVotedProducerList();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetRegisteredProducerInfo();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

// CR
- (void)generateCRInfoPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String crPublicKey    = [self cstringWithString:args[idx++]];
    String did            = [self cstringWithString:args[idx++]];
    String nickName       = [self cstringWithString:args[idx++]];
    String url            = [self cstringWithString:args[idx++]];
    long   location       = [args[idx++] longValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    //TODO: upgrade spv sdk
//    Json payloadJson = mainchainSubWallet->GenerateCRInfoPayload(crPublicKey, did, nickName, url, location);
    Json payloadJson = mainchainSubWallet->GenerateCRInfoPayload(crPublicKey, nickName, url, location);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (void)generateUnregisterCRPayload:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String did            = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json payloadJson = mainchainSubWallet->GenerateUnregisterCRPayload(did);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createRegisterCRTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;
    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json txJson = mainchainSubWallet->CreateRegisterCRTransaction(fromAddress, payloadJson, amount, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createUpdateCRTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateUpdateCRTransaction(fromAddress, payloadJson, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createUnregisterCRTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateUnregisterCRTransaction(fromAddress, payloadJson, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createRetrieveCRDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String crPublicKey    = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateRetrieveCRDepositTransaction(crPublicKey, amount, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createVoteCRTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String chainID         = [self cstringWithString:args[idx++]];
    String fromAddress     = [self cstringWithString:args[idx++]];
    Json publicKeys        = [self jsonWithString:args[idx++]];
    String memo            = [self cstringWithString:args[idx++]];
    Json invalidCandidates = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateVoteCRTransaction(fromAddress, publicKeys, memo, invalidCandidates);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)getVotedCRList:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetVotedCRList();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getRegisteredCRInfo:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetRegisteredCRInfo();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getVoteInfo:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String chainID         = [self cstringWithString:args[idx++]];
    String type            = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->GetVoteInfo(type);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (void)sponsorProposalDigest:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    int type                = [args[idx++] intValue];
    String categoryData     = [self cstringWithString:args[idx++]];
    String sponsorPublicKey = [self cstringWithString:args[idx++]];
    String draftHash        = [self cstringWithString:args[idx++]];
    Json budgets            = [self jsonWithString:args[idx++]];
    String recipient        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
//  TODO upgrade spv sdk
//    Json stringJson = mainchainSubWallet->SponsorProposalDigest(type, categoryData, sponsorPublicKey,
//            draftHash, budgets, recipient);
    Json stringJson = mainchainSubWallet->SponsorProposalDigest(type, sponsorPublicKey, draftHash, budgets, recipient);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)CRSponsorProposalDigest:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID       = [self cstringWithString:args[idx++]];
    String chainID              = [self cstringWithString:args[idx++]];
    Json sponsorSignedProposal  = [self jsonWithString:args[idx++]];
    String crSponsorDID         = [self cstringWithString:args[idx++]];
    String crOpinionHash        = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

//    Json stringJson = mainchainSubWallet->CRSponsorProposalDigest(sponsorSignedProposal, crSponsorDID, crOpinionHash);
    Json stringJson = mainchainSubWallet->CRSponsorProposalDigest(sponsorSignedProposal, crSponsorDID);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createCRCProposalTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    Json crSignedProposal   = [self jsonWithString:args[idx++]];
    String memo             = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->CreateCRCProposalTransaction(crSignedProposal, memo);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)generateCRCProposalReview:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    String proposalHash     = [self cstringWithString:args[idx++]];
    int voteResult          = [args[idx++] intValue];
    String did              = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->GenerateCRCProposalReview(proposalHash, voteResult, did);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createCRCProposalReviewTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    Json proposalReview     = [self jsonWithString:args[idx++]];
    String memo             = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->CreateCRCProposalReviewTransaction(proposalReview, memo);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createVoteCRCProposalTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    Json votes              = [self jsonWithString:args[idx++]];
    String memo             = [self cstringWithString:args[idx++]];
    Json invalidCandidates  = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->CreateVoteCRCProposalTransaction(fromAddress, votes, memo, invalidCandidates);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createImpeachmentCRCTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    Json votes              = [self jsonWithString:args[idx++]];
    String memo             = [self cstringWithString:args[idx++]];
    Json invalidCandidates  = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->CreateImpeachmentCRCTransaction(fromAddress, votes, memo, invalidCandidates);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)leaderProposalTrackDigest:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    int type                = [args[idx++] intValue];
    String proposalHash     = [self cstringWithString:args[idx++]];
    String documentHash     = [self cstringWithString:args[idx++]];
    int stage               = [args[idx++] intValue];
    String appropriation    = [self cstringWithString:args[idx++]];
    String leaderPubKey     = [self cstringWithString:args[idx++]];
    String newLeaderPubKey  = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->LeaderProposalTrackDigest(type, proposalHash, documentHash,
            stage, appropriation, leaderPubKey, newLeaderPubKey);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)newLeaderProposalTrackDigest:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    Json leaderSignedProposalTracking = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->NewLeaderProposalTrackDigest(leaderSignedProposalTracking);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)secretaryGeneralProposalTrackDigest:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    Json leaderSignedProposalTracking = [self jsonWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->SecretaryGeneralProposalTrackDigest(leaderSignedProposalTracking);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)createProposalTrackingTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID   = [self cstringWithString:args[idx++]];
    String chainID          = [self cstringWithString:args[idx++]];
    Json SecretaryGeneralSignedPayload = [self jsonWithString:args[idx++]];
    String memo             = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json stringJson = mainchainSubWallet->CreateProposalTrackingTransaction(SecretaryGeneralSignedPayload, memo);
    NSString *jsonString = [self stringWithJson:stringJson];
    return [self successAsString:command msg:jsonString];
}

- (void)syncStart:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID       = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    subWallet->SyncStart();;
    return [self successAsString:command msg:@"SyncStart OK"];
}

- (void)syncStop:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID       = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    subWallet->SyncStop();;
    return [self successAsString:command msg:@"SyncStop OK"];
}

String const IDChain = "IDChain";

- (IIDChainSubWallet*) getIDChainSubWallet:(String)masterWalletID {
     ISubWallet* subWallet = [self getSubWallet:masterWalletID :IDChain];

    return dynamic_cast<IIDChainSubWallet *>(subWallet);
 }

- (void)getResolveDIDInfo:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    int start = [args[idx++] intValue];
    int count = [args[idx++] intValue];
    String did            = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = idChainSubWallet->GetResolveDIDInfo(start, count, did);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)getAllDID:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    int start = [args[idx++] intValue];
    int count = [args[idx++] intValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Json json = idChainSubWallet->GetAllDID(start, count);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (void)didSign:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String did            = [self cstringWithString:args[idx++]];
    String message        = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    String ret = idChainSubWallet->Sign(did, message, payPassword);
    NSString *jsonString = [self stringWithJson:ret];
    return [self successAsString:command msg:jsonString];
}

- (void)didSignDigest:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String did            = [self cstringWithString:args[idx++]];
    String digest        = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    String ret = idChainSubWallet->SignDigest(did, digest, payPassword);
    NSString *jsonString = [self stringWithJson:ret];
    return [self successAsString:command msg:jsonString];
}

- (void)verifySignature:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String publicKey            = [self cstringWithString:args[idx++]];
    String message        = [self cstringWithString:args[idx++]];
    String signature    = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    Boolean ret = idChainSubWallet->VerifySignature(publicKey, message, signature);
    CDVPluginResult*  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:ret];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPublicKeyDID:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String publicKey            = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    String ret = idChainSubWallet->GetPublicKeyDID(publicKey);
    NSString *jsonString = [self stringWithJson:ret];
    return [self successAsString:command msg:jsonString];
}

- (void)generateDIDInfoPayload:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String didInfo        = [self cstringWithString:args[idx++]];
    String paypasswd      = [self cstringWithString:args[idx++]];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IIDChainSubWallet* idChainSubWallet = [self getIDChainSubWallet:masterWalletID];
    if (idChainSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:IDChain]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }

    String ret = idChainSubWallet->GenerateDIDInfoPayload(didInfo, paypasswd);
    NSString *jsonString = [self stringWithJson:ret];
    return [self successAsString:command msg:jsonString];
}

@end
