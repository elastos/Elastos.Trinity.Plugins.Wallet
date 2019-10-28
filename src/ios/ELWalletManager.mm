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

#import "ELWalletManager.h"
#import <Cordova/CDVCommandDelegate.h>

#pragma mark - ElISubWalletCallback C++

//typedef void (*MessageHandler)(const char *msg);

using namespace Elastos::ElaWallet;
class ElISubWalletCallback: public ISubWalletCallback
{
public:

    /**
     * Callback method fired when status of a transaction changed.
     * @param txid indicate hash of the transaction.
     * @param status can be "Added", "Deleted" or "Updated".
     * @param desc is an detail description of transaction status.
     * @param confirms is confirm count util this callback fired.
     */
    void OnTransactionStatusChanged(
                                    const std::string &txid,
                                    const std::string &status,
                                    const nlohmann::json &desc,
                                    uint32_t confirms) ;

    /**
     * Callback method fired when block begin synchronizing with a peer. This callback could be used to show progress.
     */
    void OnBlockSyncStarted() ;

    /**
     * Callback method fired when block end synchronizing with a peer. This callback could be used to show progress.
     */
    void OnBlockSyncStopped();

    void OnBalanceChanged(const std::string &asset, const std::string & balance);

    ElISubWalletCallback( id <CDVCommandDelegate> delegate, String &masterWalletID,
                         String &chainID, CDVInvokedUrlCommand *command);

    ~ElISubWalletCallback();


    NSDictionary *mkJson(NSString *key, id value);
    CDVPluginResult *successAsDic(CDVInvokedUrlCommand *command, NSDictionary* dic);
    CDVPluginResult *errorProcess(CDVInvokedUrlCommand *command, int code, id msg);
    void OnBlockSyncProgress(uint32_t currentBlockHeight, uint32_t estimatedHeight, time_t lastBlockTime);
    void OnTxPublished(const std::string &hash, const nlohmann::json &result);
    void OnAssetRegistered(const std::string &asset, const nlohmann::json &info);
    void OnConnectStatusChanged(const std::string &status);

private:

    id <CDVCommandDelegate> myDelegate;
    String walletID;
    String chID;
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
    walletID = masterWalletID;
    chID = chainID;
    myDelegate = delegate;
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

NSDictionary *ElISubWalletCallback::mkJson(NSString *key, id value)
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:value forKey:key];
    NSDictionary *resDic = dic;
    return resDic;

}
CDVPluginResult *ElISubWalletCallback::successAsDic(CDVInvokedUrlCommand *command, NSDictionary* dic)
{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    return pluginResult;

}
CDVPluginResult *ElISubWalletCallback::errorProcess(CDVInvokedUrlCommand *command, int code, id msg)
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:code] forKey:keyCode];
    [dic setValue:msg forKey:keyMessage];

    //    NSDictionary *jsonDic = mkJson(keyError, dic);
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary: dic];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    //    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return pluginResult;
}

void ElISubWalletCallback::OnTransactionStatusChanged(const std::string &txid, const std::string &status,
                                                      const nlohmann::json &desc, uint32_t confirms)
{
    NSLog(@" ----OnTransactionStatusChanged ----\n");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *txIdStr = [NSString stringWithCString:txid.c_str() encoding:NSUTF8StringEncoding];
    NSString *statusStr = [NSString stringWithCString:status.c_str() encoding:NSUTF8StringEncoding];
    NSString *descStr = [NSString stringWithCString:desc.dump().c_str() encoding:NSUTF8StringEncoding];
    NSNumber *confirmNum = [NSNumber numberWithInt:confirms];
    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:txIdStr forKey:@"txId"];
    [dic setValue:statusStr forKey:@"status"];
    [dic setValue:descStr forKey:@"desc"];
    [dic setValue:confirmNum forKey:@"confirms"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnTransactionStatusChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}


void ElISubWalletCallback::OnBlockSyncStarted()
{
    NSLog(@" ----OnBlockSyncStarted ----\n");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnBlockSyncStarted" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

void ElISubWalletCallback::OnBlockSyncProgress(uint32_t currentBlockHeight, uint32_t estimatedHeight, time_t lastBlockTime)
{
    int progress = estimatedHeight;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSNumber *currentBlockHeightNum = [NSNumber numberWithInt:currentBlockHeight];
    NSNumber *progressNum = [NSNumber numberWithInt:progress];

    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:currentBlockHeightNum forKey:@"currentBlockHeight"];
    [dic setValue:progressNum forKey:@"estimatedHeight"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnBlockSyncProgress" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

void ElISubWalletCallback::OnTxPublished(const std::string &hash, const nlohmann::json &result)
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    NSString *hashString = [NSString stringWithCString:hash.c_str() encoding:NSUTF8StringEncoding];
    NSString *resultString = [NSString stringWithCString:result.dump().c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:hashString forKey:@"hash"];
    [dic setValue:resultString forKey:@"result"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnTxPublished" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

void ElISubWalletCallback::OnAssetRegistered(const std::string &asset, const nlohmann::json &info)
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    NSString *assetString = [NSString stringWithCString:asset.c_str() encoding:NSUTF8StringEncoding];
    NSString *infoString = [NSString stringWithCString:info.dump().c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:assetString forKey:@"asset"];
    [dic setValue:infoString forKey:@"info"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnAssetRegistered" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

void ElISubWalletCallback::OnConnectStatusChanged(const std::string &status)
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    NSString *statusString = [NSString stringWithCString:status.c_str() encoding:NSUTF8StringEncoding];


    [dic setValue:statusString forKey:@"status"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnConnectStatusChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];

}

/**
 * Callback method fired when block end synchronizing with a peer. This callback could be used to show progress.
 */
void ElISubWalletCallback::OnBlockSyncStopped()
{
    NSLog(@" ----OnBlockSyncStopped ----\n");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnBlockSyncStopped" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);
    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

void ElISubWalletCallback::OnBalanceChanged(const std::string &asset, const std::string &balance)
{
    NSLog(@" ----OnBalanceChanged ----\n");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    NSString *walletIDString = [NSString stringWithCString:walletID.c_str() encoding:NSUTF8StringEncoding];
    NSString *chainIDString = [NSString stringWithCString:chID.c_str() encoding:NSUTF8StringEncoding];

    NSString *assetString = [NSString stringWithCString:asset.c_str() encoding:NSUTF8StringEncoding];
    NSString *balanceString = [NSString stringWithCString:balance.c_str() encoding:NSUTF8StringEncoding];

    [dic setValue:assetString forKey:@"Asset"];
    [dic setValue:balanceString forKey:@"Balance"];
    [dic setValue:walletIDString forKey:@"MasterWalletID"];
    [dic setValue:chainIDString forKey:@"ChaiID"];
    [dic setValue:@"OnBalanceChanged" forKey:@"Action"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = successAsDic(mCommand, dic);

    [myDelegate sendPluginResult:pluginResult callbackId:mCommand.callbackId];
}

#pragma mark - ELWalletManager

@interface ELWalletManager ()
{
    //    ELIIdManagerCallback *iidCallback;
}

@end


@implementation ELWalletManager

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
    for (int i = 0; i < subWalletList.size(); i++)
    {
        ISubWallet *iSubWallet = subWalletList[i];
        NSString *getChainIDString = [self stringWithCString:iSubWallet->GetChainID()];
        NSString *chainIDString = [self stringWithCString:chainID];

        if ([chainIDString isEqualToString:getChainIDString])
        {
            return iSubWallet;
        }
    }
    return nil;
}
- (void)createDIDManager:(IMasterWallet *)masterWallet
{

}

//- (IDidManager *)getDIDManager:(String)masterWalletID
//{
//    DIDManagerMap managerMap = *mDIDManagerMap;
//    DIDManagerMap::iterator iter;
//    //面对关联式容器，应该使用其所提供的find函数来搜索元素，会比使用STL算法find()更有效率。因为STL算法find()只是循环搜索。
//    iter = managerMap.find(masterWalletID);
//    if(iter == managerMap.end())
//    {
//        return nil;
//    }
//
//    IDidManager *manager = managerMap[masterWalletID];
//    return manager;
//}

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

- (CDVPluginResult *)errCodeInvalidArg:(CDVInvokedUrlCommand *)command code:(int)code idx:(int)idx
{
    NSString *msg = [NSString stringWithFormat:@"%d %@", idx, @" parameters are expected"];
    return [self errorProcess:command code:code msg:msg];
}

- (CDVPluginResult *)successAsDic:(CDVInvokedUrlCommand *)command  msg:(NSDictionary*) dic
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];

}

- (CDVPluginResult *)successAsString:(CDVInvokedUrlCommand *)command  msg:(NSString*) msg
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
}

- (CDVPluginResult *)errorProcess:(CDVInvokedUrlCommand *)command  code : (int) code msg:(id) msg
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:code] forKey:keyCode];
    [dic setValue:msg forKey:keyMessage];

    //    NSDictionary *jsonDic = [self mkJson:keyError value:dic];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
    //    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return pluginResult;
}
- (NSDictionary *)parseOneParam:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:value forKey:key];
    return dic;
}


- (NSDictionary *)mkJson:(NSString *)key value:(id)value
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:value forKey:key];
    NSDictionary *resDic = dic;
    return resDic;

}
- (NSString *)dicToJSONString:(NSDictionary *)dic
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
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

#pragma mark - removeListener

- (void)removeListenerWithChainID:(String)chainID
{
    NSString *chainIDString = [self stringWithCString:chainID];

    if(isubWalletVector != nil && isubWalletCallBackVector != nil)
    {
        //        isubWalletVector = new ISubWalletVector();
        std::vector<ISubWallet *> isubWalletV = *(isubWalletVector);
        std::vector<ISubWalletCallback *> callBack = *(isubWalletCallBackVector);
        for (int i = 0; i < isubWalletV.size(); i++)
        {
            ISubWallet *iSubWallet  = isubWalletVector->at(i);
            NSString *getChainIDString = [self stringWithCString:iSubWallet->GetChainID()];


            if ([chainIDString isEqualToString:getChainIDString])
            {
                //                std::vector<ISubWallet *>::iterator sub;
                //                sub = isubWalletV.begin() + i;

                ISubWalletCallback *call = isubWalletCallBackVector->at(i);
                iSubWallet->RemoveCallback(call);

                isubWalletVector->erase(isubWalletVector->begin() + i);
                isubWalletCallBackVector->erase(isubWalletCallBackVector->begin() + i);
            }


        }
    }
}

- (void)removeListener
{
    if(isubWalletVector != nil && isubWalletCallBackVector != nil)
    {
        //        isubWalletVector = new ISubWalletVector();
        std::vector<ISubWallet *> isubWalletV = *(isubWalletVector);
        std::vector<ISubWalletCallback *> callBack = *(isubWalletCallBackVector);
        for (int i = 0; i < isubWalletV.size(); i++)
        {
            ISubWallet *wallet  = isubWalletVector->at(i);
            ISubWalletCallback *call = isubWalletCallBackVector->at(i);
            wallet->RemoveCallback(call);

        }
        isubWalletVector->clear();
        isubWalletCallBackVector->clear();
        delete isubWalletVector;
        delete isubWalletCallBackVector;
        isubWalletVector = nil;
        isubWalletCallBackVector = nil;
    }
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

- (void)pluginInitialize:(NSString *)path
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

    //    mDIDManagerMap  = new DIDManagerMap();
    //    mDIDManagerSupervisor = NULL;
    mMasterWalletManager = NULL;
    //private IDidManager mDidManager = null;
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
    errCodeInvalidDIDManager          = 10011;
    errCodeInvalidDID                 = 10012;
    errCodeActionNotFound             = 10013;

    errCodeWalletException            = 20000;

    mRootPath = path;
    const char  *rootPath = [mRootPath UTF8String];
    mMasterWalletManager = new MasterWalletManager(rootPath);

}
- (CDVPluginResult *)coolMethod:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    return pluginResult;

}


- (CDVPluginResult *)print:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    NSString *text = [command.arguments objectAtIndex:0];

    if(!text || ![text isEqualToString:@""])
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self parseOneParam:@"text" value:text]];

    }
    else
    {
        NSString *error = @"Text not can be null";
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    }
    return pluginResult;
}

- (CDVPluginResult *)getAllMasterWallets:(CDVInvokedUrlCommand *)command
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
- (CDVPluginResult *)createMasterWallet:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *array = command.arguments;

    String masterWalletID = [self cstringWithString:[array objectAtIndex:idx++]];
    String mnemonic       = [self cstringWithString:[array objectAtIndex:idx++]];;
    String phrasePassword = [self cstringWithString:[array objectAtIndex:idx++]];;
    String payPassword    = [self cstringWithString:[array objectAtIndex:idx++]];
    Boolean singleAddress = [[array objectAtIndex:idx++] boolValue];

    NSArray *args = command.arguments;
    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    IMasterWallet *masterWallet = mMasterWalletManager->CreateMasterWallet(
                                                                           masterWalletID, mnemonic, phrasePassword, payPassword, singleAddress);

    if (masterWallet == NULL) {
        NSString *msg = [NSString stringWithFormat:@"Create %@", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];

    }

    NSString *jsonString = [self getBasicInfo:masterWallet];
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)generateMnemonic:(CDVInvokedUrlCommand *)command
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
    NSDictionary *dic = [self mkJson:keySuccess value:mnemonicString];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    return pluginResult;

}
- (CDVPluginResult *)createSubWallet:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    long feePerKb         = [args[idx++] boolValue];;

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }

    ISubWallet *subWallet = masterWallet->CreateSubWallet(chainID, feePerKb);
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Create", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeCreateSubWallet msg:msg];
    }
    Json json = subWallet->GetBasicInfo();
    NSString *jsonString = [self stringWithCString:json.dump()];

    return [self successAsString:command msg:jsonString];

}
- (CDVPluginResult *)getAllSubWallets:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }

    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
    if (masterWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
    }
    NSMutableArray *subWalletJsonArray = [[NSMutableArray alloc] init];
    ISubWalletVector subWalletList = masterWallet->GetAllSubWallets();
    for (int i = 0; i < subWalletList.size(); i++)
    {
        ISubWallet *iSubWallet = subWalletList[i];
        String chainId = iSubWallet->GetChainID();
        NSString *chainIdString = [self stringWithCString:chainId];
        [subWalletJsonArray addObject:chainIdString];
    }
    NSString *msg = [self arrayToJSONString:subWalletJsonArray];
    return [self successAsString:command msg:msg];

}

- (CDVPluginResult *)registerWalletListener:(CDVInvokedUrlCommand *)command : (id <CDVCommandDelegate>) delegate
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *getSubWallet = [self getSubWallet:masterWalletID :chainID];
    if (getSubWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    if(isubWalletVector == nil)
    {
        isubWalletVector = new ISubWalletVector();
    }

    if(isubWalletCallBackVector == nil)
    {
        isubWalletCallBackVector = new ISubWalletCallbackVector();
    }
    ElISubWalletCallback *subCallback =  new ElISubWalletCallback(delegate, masterWalletID, chainID, command);
    getSubWallet->AddCallback(subCallback);

    isubWalletVector->push_back(getSubWallet);
    isubWalletCallBackVector->push_back(subCallback);

    return nil;
}

- (CDVPluginResult *)getBalance:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];;
    String chainID        = [self cstringWithString:args[idx++]];;
    int balanceType       = [args[idx++] intValue];

    BalanceType type = Default;
    if(balanceType == 0)
    {

    }
    else if(balanceType == 1)
    {
        type = Voted;
    }
    else
    {
        type = Total;
    }

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeCreateSubWallet msg:msg];
    }

    String balance = subWallet->GetBalance(type);
    NSString *balanceStr = [self stringWithCString:balance];

    return [self successAsString:command msg:balanceStr];


}
- (CDVPluginResult *)getSupportedChains:(CDVInvokedUrlCommand *)command
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
    for(int i = 0; i < stringVec.size(); i++)
    {
        String string = stringVec[i];
        NSString *sstring = [self stringWithCString:string];
        [stringArray addObject:sstring];
    }
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:stringArray];
}

- (CDVPluginResult *)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command
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

- (CDVPluginResult *)getAllTransaction:(CDVInvokedUrlCommand *)command
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
- (CDVPluginResult *)createAddress:(CDVInvokedUrlCommand *)command
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

- (CDVPluginResult *)getGenesisAddress:(CDVInvokedUrlCommand *)command
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
    if(sidechainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of ISidechainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String address = sidechainSubWallet->GetGenesisAddress();
    NSString *jsonString = [self stringWithCString:address];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command
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
    Json json = masterWallet->GetPublicKey();
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command
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

    Json json = mMasterWalletManager->ExportWalletWithKeystore(masterWallet, backupPassword, payPassword);
    String str = json.dump();
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command
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

    Json json = mMasterWalletManager->ExportWalletWithMnemonic(masterWallet, backupPassword);

    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)changePassword:(CDVInvokedUrlCommand *)command
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

- (CDVPluginResult *)importWalletWithKeystore:(CDVInvokedUrlCommand *)command
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
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command
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
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String mnemonic = [self cstringWithString:args[idx++]];
    String phrasePassword = [self cstringWithString:args[idx++]];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }

    String pubKey = mMasterWalletManager->GetMultiSignPubKey(mnemonic, phrasePassword);

    NSString *jsonString = [self stringWithCString:pubKey];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String mnemonic       = [self cstringWithString:args[idx++]];
    String phrasePassword = [self cstringWithString:args[idx++]];
    String payPassword    = [self cstringWithString:args[idx++]];
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
                                                                                    masterWalletID, mnemonic, phrasePassword, payPassword, publicKeys, m, timestamp);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Create multi sign", [self formatWalletName:masterWalletID], @"with mnemonic"];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command
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
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String privKey = [self cstringWithString:args[idx++]];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }

    String privateKey = mMasterWalletManager->GetMultiSignPubKey(privKey);

    NSString *jsonString = [self stringWithCString:privateKey];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;


    String masterWalletID = [self cstringWithString:args[idx++]];
    String privKey       = [self cstringWithString:args[idx++]];
    String payPassword = [self cstringWithString:args[idx++]];
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
                                                                                    masterWalletID, privKey, payPassword, publicKeys, m, timestamp);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Create multi sign", [self formatWalletName:masterWalletID], @"with private key"];
        return [self errorProcess:command code:errCodeCreateMasterWallet msg:msg];
    }
    NSString *jsonString = [self getBasicInfo:masterWallet];
    [self createDIDManager:masterWallet];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)getAllAddress:(CDVInvokedUrlCommand *)command
{

    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID       = [self cstringWithString:args[idx++]];
    int start = [args[idx++] intValue];
    int count = [args[idx++] intValue];

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

- (CDVPluginResult *)isAddressValid:(CDVInvokedUrlCommand *)command
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
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:valid];
}

- (CDVPluginResult *)createDepositTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    String lockedAddress      = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String sideChainAddress  = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];
    BOOL useVotedUTXO   = [args[idx++] boolValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->CreateDepositTransaction(fromAddress, lockedAddress, amount, sideChainAddress, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithCString:json.dump()];
    return [self successAsString:command msg:jsonString];

}

//- (CDVPluginResult *)destroyWallet:(CDVInvokedUrlCommand *)command
//{
//    int idx = 0;
//    NSArray *args = command.arguments;
//
//    String masterWalletID = [self cstringWithString:args[idx++]];
//
//    if (args.count != idx) {
//
//        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
//    }
//    IMasterWallet *masterWallet = [self getIMasterWallet:masterWalletID];
//    if (masterWallet == nil) {
//        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletName:masterWalletID]];
//        return [self errorProcess:command code:errCodeInvalidMasterWallet msg:msg];
//    }
//
//    ISubWalletVector subWallets = masterWallet->GetAllSubWallets();
//
//        IDidManager DIDManager = getDIDManager(masterWalletID);
//        if (DIDManager != null) {
//            // TODO destroy did manager
//        }
//    if (mMasterWalletManager == nil) {
//        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
//        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
//    }
//    [self removeListener];
//    mMasterWalletManager->DestroyWallet(masterWalletID);
//    NSString *msg = [NSString stringWithFormat:@"Destroy %@ OK", [self formatWalletName:masterWalletID]];
//    return [self successAsString:command msg:msg];
//
//}

- (CDVPluginResult *)createTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    String toAddress      = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];

    String memo           = [self cstringWithString:args[idx++]];
    BOOL useVotedUTXO  = [args[idx++] boolValue];

    if (args.count != idx) {
        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }


    Json json = subWallet->CreateTransaction(fromAddress, toAddress, amount, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];


}

- (CDVPluginResult *)signTransaction:(CDVInvokedUrlCommand *)command
{

    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json rawTransaction    = [self jsonWithString:args[idx++]];
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

- (CDVPluginResult *)publishTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    Json rawTxJson      =  [self jsonWithString:args[idx++]];

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

// - (CDVPluginResult *)saveConfigs:(CDVInvokedUrlCommand *)command
// {
//     if(mMasterWalletManager)
//     {
//         mMasterWalletManager->SaveConfigs();
//     }
//     NSString *msg = @"Configuration files save successfully";
//     return [self successAsString:command msg:msg];
// }

- (CDVPluginResult *)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID  = [self cstringWithString:args[idx++]];
    String keystoreContent = [self cstringWithString:args[idx++]];
    String backupPassword  = [self cstringWithString:args[idx++]];
    String payPassword     = [self cstringWithString:args[idx++]];
    String phrasePassword  = [self cstringWithString:args[idx++]];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    IMasterWallet *masterWallet = mMasterWalletManager->ImportWalletWithKeystore(         masterWalletID, keystoreContent, backupPassword, payPassword);
    if (masterWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@", @"Import", [self formatWalletName:masterWalletID], @"with keystore"];
        return [self errorProcess:command code:errCodeImportFromKeyStore msg:msg];
    }
    [self createDIDManager:masterWallet];
    NSString *jsonString = [self getBasicInfo:masterWallet];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command
{

    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID       = [self cstringWithString:args[idx++]];
    Json rawTxJson = [self jsonWithString:args[idx++]];

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

- (CDVPluginResult *)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command
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
    String str = subWallet->GetPublicKey();
    NSString *msg = [self stringWithCString:str];
    return [self successAsString:command msg:msg];

}

- (CDVPluginResult *)removeWalletListener:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID       = [self cstringWithString:args[idx++]];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    [self removeListener];

    NSString *msg = [NSString stringWithFormat:@"%@ %@", @"remove listener", [self formatWalletNameWithString:masterWalletID other:chainID]];
    return [self successAsString:command msg:msg];
}

- (CDVPluginResult *)createIdTransaction:(CDVInvokedUrlCommand *)command
{
    NSArray *args = command.arguments;
    int idx = 0;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    Json programJson      = [self jsonWithString:args[idx++]];
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
    if(idchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"is not instance of IIDChainSubWallet", [self formatWalletNameWithString:masterWalletID other:chainID]];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json json = idchainSubWallet->CreateIDTransaction(fromAddress, payloadJson, programJson, memo);
    NSString *msg = [self stringWithJson:json];
    return [self successAsString:command msg:msg];

}

- (CDVPluginResult *)createWithdrawTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress    = [self cstringWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String mainchainAddress  = [self jsonWithString:args[idx++]];
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
    if(sidechainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of ISidechainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = sidechainSubWallet->CreateWithdrawTransaction(fromAddress, amount, mainchainAddress, memo);
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];

}

- (CDVPluginResult *)getMasterWallet:(CDVInvokedUrlCommand *)command
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

- (CDVPluginResult *)destroySubWallet:(CDVInvokedUrlCommand *)command
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
    [self removeListenerWithChainID:chainID];
    masterWallet->DestroyWallet(subWallet);


    NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Destroy", [self formatWalletNameWithString:masterWalletID other:chainID]];
    return [self successAsString:command msg:msg];
}

- (CDVPluginResult *)getVersion:(CDVInvokedUrlCommand *)command
{
    if (mMasterWalletManager == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@", @"Master wallet manager has not initialize"];
        return [self errorProcess:command code:errCodeInvalidMasterWalletManager msg:msg];
    }
    String version = mMasterWalletManager->GetVersion();
    NSString *msg = [self stringWithCString:version];
    return [self successAsString:command msg:msg];
}

- (CDVPluginResult *)generateProducerPayload:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }
    Json payloadJson = mainchainSubWallet->GenerateProducerPayload(publicKey, nodePublicKey, nickName, url, IPAddress, location, payPasswd);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }


    String payloadJson = mainchainSubWallet->GenerateCancelProducerPayload(publicKey, payPasswd);
    NSString *jsonString = [self stringWithJson:payloadJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command
{

    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String amount         = [self cstringWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];
    bool useVotedUTXO  = [args[idx++] boolValue];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }


    Json txJson = mainchainSubWallet->CreateRegisterProducerTransaction(fromAddress, payloadJson, amount, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];
    bool useVotedUTXO  = [args[idx++] boolValue];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson = mainchainSubWallet->CreateUpdateProducerTransaction(fromAddress, payloadJson, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    Json payloadJson      = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];
    bool useVotedUTXO  = [args[idx++] boolValue];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateCancelProducerTransaction(fromAddress, payloadJson, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json txJson =  mainchainSubWallet->CreateRetrieveDepositTransaction(amount, memo);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)getPublicKeyForVote:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String msg = mainchainSubWallet->GetOwnerPublicKey();
    NSString *jsonString = [self stringWithCString:msg];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command
{
    int idx = 0;
    NSArray *args = command.arguments;

    String masterWalletID = [self cstringWithString:args[idx++]];
    String chainID        = [self cstringWithString:args[idx++]];
    String fromAddress      = [self cstringWithString:args[idx++]];
    String stake      = [self cstringWithString:args[idx++]];
    Json publicKeys = [self jsonWithString:args[idx++]];
    String memo           = [self cstringWithString:args[idx++]];
    bool useVotedUTXO  = [args[idx++] boolValue];

    if (args.count != idx) {

        return [self errCodeInvalidArg:command code:errCodeInvalidArg idx:idx];
    }
    ISubWallet *subWallet = [self getSubWallet:masterWalletID :chainID];
    if (subWallet == nil) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", @"Get", [self formatWalletNameWithString:masterWalletID other:chainID]];

        return [self errorProcess:command code:errCodeInvalidSubWallet msg:msg];
    }
    IMainchainSubWallet *mainchainSubWallet = dynamic_cast<IMainchainSubWallet *>(subWallet);
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    String txJson = mainchainSubWallet->CreateVoteProducerTransaction(fromAddress, stake, publicKeys, memo, useVotedUTXO);
    NSString *jsonString = [self stringWithJson:txJson];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)getVotedProducerList:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetVotedProducerList();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

- (CDVPluginResult *)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command
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
    if(mainchainSubWallet == nil)
    {
        NSString *msg = [NSString stringWithFormat:@"%@ %@", [self formatWalletNameWithString:masterWalletID other:chainID], @" is not instance of IMainchainSubWallet"];
        return [self errorProcess:command code:errCodeSubWalletInstance msg:msg];
    }

    Json json = mainchainSubWallet->GetRegisteredProducerInfo();
    NSString *jsonString = [self stringWithJson:json];
    return [self successAsString:command msg:jsonString];
}

@end

