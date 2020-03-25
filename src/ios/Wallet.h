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
#import "IMasterWallet.h"
#import "MasterWalletManager.h"
#import "ISidechainSubWallet.h"
#import "IMainchainSubWallet.h"
#import "IIDChainSubWallet.h"
#import <string.h>
#import <map>
#import "TrinityPlugin.h"

typedef Elastos::ElaWallet::IMasterWallet IMasterWallet;
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
typedef Elastos::ElaWallet::IIDChainSubWallet IIDChainSubWallet;



@interface Wallet : TrinityPlugin {
    NSString *TAG; //= @"Wallet";
    MasterWalletManager *mMasterWalletManager;// = null;
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
}
- (void)initialize:(TrinityPlugin*)plugin;
- (void)coolMethod:(CDVInvokedUrlCommand *)command;
- (void)print:(CDVInvokedUrlCommand *)command;
- (void)getAllMasterWallets:(CDVInvokedUrlCommand *)command;
- (void)createMasterWallet:(CDVInvokedUrlCommand *)command;
- (void)generateMnemonic:(CDVInvokedUrlCommand *)command;
- (void)createSubWallet:(CDVInvokedUrlCommand *)command;
- (void)getAllSubWallets:(CDVInvokedUrlCommand *)command;
- (void)registerWalletListener:(CDVInvokedUrlCommand *)command :(id <CDVCommandDelegate>) delegate;
- (void)getBalance:(CDVInvokedUrlCommand *)command;
- (void)getBalanceInfo:(CDVInvokedUrlCommand *)command;
- (void)getSupportedChains:(CDVInvokedUrlCommand *)command;
- (void)getMasterWalletBasicInfo:(CDVInvokedUrlCommand *)command;
- (void)getAllTransaction:(CDVInvokedUrlCommand *)command;
- (void)createAddress:(CDVInvokedUrlCommand *)command;
- (void)getGenesisAddress:(CDVInvokedUrlCommand *)command;
// - (void)getMasterWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (void)exportWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (void)exportWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)changePassword:(CDVInvokedUrlCommand *)command;
- (void)importWalletWithKeystore:(CDVInvokedUrlCommand *)command;
- (void)importWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)getMultiSignPubKeyWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWalletWithMnemonic:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWallet:(CDVInvokedUrlCommand *)command;
// - (void)getMultiSignPubKeyWithPrivKey:(CDVInvokedUrlCommand *)command;
- (void)createMultiSignMasterWalletWithPrivKey:(CDVInvokedUrlCommand *)command;
- (void)getAllAddress:(CDVInvokedUrlCommand *)command;
- (void)getAllPublicKeys:(CDVInvokedUrlCommand *)command;
- (void)isAddressValid:(CDVInvokedUrlCommand *)command;
- (void)createDepositTransaction:(CDVInvokedUrlCommand *)command;
- (void)destroyWallet:(CDVInvokedUrlCommand *)command;
- (void)createTransaction:(CDVInvokedUrlCommand *)command;
- (void)createTransaction:(CDVInvokedUrlCommand *)command;
- (void)getAllUTXOs:(CDVInvokedUrlCommand *)command;
- (void)signTransaction:(CDVInvokedUrlCommand *)command;
- (void)publishTransaction:(CDVInvokedUrlCommand *)command;
// - (void)importWalletWithOldKeystore:(CDVInvokedUrlCommand *)command;
- (void)getTransactionSignedSigners:(CDVInvokedUrlCommand *)command;
// - (void)getSubWalletPublicKey:(CDVInvokedUrlCommand *)command;
- (void)removeWalletListener:(CDVInvokedUrlCommand *)command;
- (void)createIdTransaction:(CDVInvokedUrlCommand *)command;
- (void)createWithdrawTransaction:(CDVInvokedUrlCommand *)command;
- (void)getMasterWallet:(CDVInvokedUrlCommand *)command;
- (void)destroySubWallet:(CDVInvokedUrlCommand *)command;
- (void)getVersion:(CDVInvokedUrlCommand *)command;
- (void)generateProducerPayload:(CDVInvokedUrlCommand *)command;
- (void)generateCancelProducerPayload:(CDVInvokedUrlCommand *)command;
- (void)createRegisterProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createUpdateProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createCancelProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)createRetrieveDepositTransaction:(CDVInvokedUrlCommand *)command;
- (void)getOwnerPublicKey:(CDVInvokedUrlCommand *)command;
- (void)createVoteProducerTransaction:(CDVInvokedUrlCommand *)command;
- (void)getVotedProducerList:(CDVInvokedUrlCommand *)command;
- (void)getRegisteredProducerInfo:(CDVInvokedUrlCommand *)command;

//CR
- (void)generateCRInfoPayload:(CDVInvokedUrlCommand *)command;
- (void)generateUnregisterCRPayload:(CDVInvokedUrlCommand *)command;
- (void)createRegisterCRTransaction:(CDVInvokedUrlCommand *)command;
- (void)createUpdateCRTransaction:(CDVInvokedUrlCommand *)command;
- (void)createUnregisterCRTransaction:(CDVInvokedUrlCommand *)command;
- (void)createRetrieveCRDepositTransaction:(CDVInvokedUrlCommand *)command;
- (void)createVoteCRTransaction:(CDVInvokedUrlCommand *)command;
- (void)getVotedCRList:(CDVInvokedUrlCommand *)command;
- (void)getRegisteredCRInfo:(CDVInvokedUrlCommand *)command;
- (void)getVoteInfo:(CDVInvokedUrlCommand *)command;

- (void)sponsorProposalDigest:(CDVInvokedUrlCommand *)command;
- (void)CRSponsorProposalDigest:(CDVInvokedUrlCommand *)command;
- (void)createCRCProposalTransaction:(CDVInvokedUrlCommand *)command;
- (void)generateCRCProposalReview:(CDVInvokedUrlCommand *)command;
- (void)createCRCProposalReviewTransaction:(CDVInvokedUrlCommand *)command;
- (void)createVoteCRCProposalTransaction:(CDVInvokedUrlCommand *)command;
- (void)createImpeachmentCRCTransaction:(CDVInvokedUrlCommand *)command;
- (void)leaderProposalTrackDigest:(CDVInvokedUrlCommand *)command;
- (void)newLeaderProposalTrackDigest:(CDVInvokedUrlCommand *)command;
- (void)secretaryGeneralProposalTrackDigest:(CDVInvokedUrlCommand *)command;
- (void)createProposalTrackingTransaction:(CDVInvokedUrlCommand *)command;

- (void)syncStart:(CDVInvokedUrlCommand *)command;
- (void)syncStop:(CDVInvokedUrlCommand *)command;
- (void)getResolveDIDInfo:(CDVInvokedUrlCommand *)command;
- (void)didSign:(CDVInvokedUrlCommand *)command;
- (void)didSignDigest:(CDVInvokedUrlCommand *)command;
- (void)verifySignature:(CDVInvokedUrlCommand *)command;
- (void)getPublicKeyDID:(CDVInvokedUrlCommand *)command;
- (void)generateDIDInfoPayload:(CDVInvokedUrlCommand *)command;


@end
