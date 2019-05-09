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

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
//#import "MyUtil.h"
#import "IMasterWallet.h"
//#import "IDidManager.h"
//#import "DIDManagerSupervisor.h"
#import "MasterWalletManager.h"
#import "ISidechainSubWallet.h"
#import "IMainchainSubWallet.h"
#import "IIdChainSubWallet.h"
//#import "IDidManager.h"
//#import "idid.h"
#import <string.h>
#import <map>

typedef Elastos::ElaWallet::IMasterWallet IMasterWallet;
//typedef Elastos::DID::DIDManagerSupervisor DIDManagerSupervisor;
typedef Elastos::ElaWallet::MasterWalletManager MasterWalletManager;
typedef Elastos::ElaWallet::ISubWallet ISubWallet;
typedef std::string String;
typedef nlohmann::json Json;
typedef std::vector<IMasterWallet *> IMasterWalletVector;
typedef std::vector<ISubWallet *> ISubWalletVector;
typedef std::vector<String> StringVector;

typedef Elastos::ElaWallet::ISubWalletCallback ISubWalletCallback;
typedef Elastos::ElaWallet::ISidechainSubWallet ISidechainSubWallet;
typedef Elastos::ElaWallet::IMainchainSubWallet IMainchainSubWallet;
typedef std::vector<ISubWalletCallback *> ISubWalletCallbackVector;
typedef Elastos::ElaWallet::IIdChainSubWallet IIdChainSubWallet;

//typedef Elastos::DID::IDIDManager IDidManager;
//typedef Elastos::DID::IDID IDID;

//typedef std::map<String, IDidManager*> DIDManagerMap;


@interface ELWalletManager : NSObject {
    // Member variables go here.
    NSString *TAG; //= @"Wallet";
//    DIDManagerMap *mDIDManagerMap;// = new HashMap<String, IDidManager>();
//    DIDManagerSupervisor *mDIDManagerSupervisor;// = null;
    MasterWalletManager *mMasterWalletManager;// = null;
    // IDidManager mDidManager = null;
    NSString *mRootPath;// = null;
    
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
    
    ISubWalletVector *isubWalletVector;
    ISubWalletCallbackVector *isubWalletCallBackVector;
    
    
//    Map<String, IDidManager> mDIDManagerMap = new HashMap<String, IDidManager>();
}
- (void)pluginInitialize:(NSString *)path;
- (CDVPluginResult *)coolMethod:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)print:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getAllMasterWallets:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createMasterWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)generateMnemonic:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createSubWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getAllSubWallets:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)registerWalletListener:(CDVInvokedUrlCommand *)command :(id <CDVCommandDelegate>) delegate;
- (CDVPluginResult *)getBalance:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getSupportedChains:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getAllTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createAddress:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getGenesisAddress:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)changePassword:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)importWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getAllAddress:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)isAddressValid:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createDepositTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)destroyWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)calculateTransactionFee:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)updateTransactionFee:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)signTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)publishTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)saveConfigs:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)encodeTransactionToString:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)decodeTransactionFromString:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createMultiSignTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)removeWalletListener:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createIdTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createDID:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didGenerateProgram:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getDIDList:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)destoryDID:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didSetValue:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didGetValue:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didGetHistoryValue:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didGetAllKeys:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didSign:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didCheckSign:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)didGetPublicKey:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)registerIdListener:(CDVInvokedUrlCommand *)command : (id <CDVCommandDelegate>) delegate;
- (CDVPluginResult *)createWithdrawTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getMasterWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)destroySubWallet:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getVersion:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)generateProducerPayload:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getPublicKeyForVote:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getVotedProducerList:(CDVInvokedUrlCommand *)command;
- (CDVPluginResult *)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command;

@end



