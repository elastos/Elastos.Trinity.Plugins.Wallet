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

let exec = cordova.exec;

function _exec(success, error, obj, fun, args) {
    function _onSuccess(ret) {
        if (success) {
            if (typeof(ret) == "string") {
                ret = JSON.parse(ret);
            }
            success(ret);
        }
    };
    exec(_onSuccess, error, obj, fun, args)
}

class WalletManagerImpl implements WalletPlugin.WalletManager {
    // print(args, success, error) {
    //     exec(success, error, "Wallet", "print", args);
    // };

    //MasterWalletManager

    generateMnemonic(args, success, error) {
        exec(success, error, "Wallet", "generateMnemonic", args);
    };

    createMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMasterWallet", args);
    };

    createMultiSignMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWallet", args);
    };

    createMultiSignMasterWalletWithPrivKey(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithPrivKey", args);
    };

    createMultiSignMasterWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithMnemonic", args);
    };

    importWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithKeystore", args);
    };

    importWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithMnemonic", args);
    };

    getAllMasterWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllMasterWallets", args);
    };

    destroyWallet(args, success, error) {
        exec(success, error, "Wallet", "destroyWallet", args);
    };

    getVersion(args, success, error) {
        exec(success, error, "Wallet", "getVersion", args);
    };

    //MasterWallet

    getMasterWalletBasicInfo(args, success, error) {
        _exec(success, error, "Wallet", "getMasterWalletBasicInfo", args);
    };

    getAllSubWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllSubWallets", args);
    };

    createSubWallet(args, success, error) {
        exec(success, error, "Wallet", "createSubWallet", args);
    };

    exportWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithKeystore", args);
    };

    exportWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithMnemonic", args);
    };

    verifyPassPhrase(args, success, error) {
        exec(success, error, "Wallet", "verifyPassPhrase", args);
    };

    verifyPayPassword(args, success, error) {
        exec(success, error, "Wallet", "verifyPayPassword", args);
    };

    destroySubWallet(args, success, error) {
        exec(success, error, "Wallet", "destroySubWallet", args);
    };

    getPubKeyInfo(args, success, error) {
        exec(success, error, "Wallet", "getPubKeyInfo", args);
    };

    isAddressValid(args, success, error) {
        exec(success, error, "Wallet", "isAddressValid", args);
    };

    getSupportedChains(args, success, error) {
        exec(success, error, "Wallet", "getSupportedChains", args);
    };

    changePassword(args, success, error) {
        exec(success, error, "Wallet", "changePassword", args);
    };

    //SubWallet

    syncStart(args, success, error) {
      exec(success, error, "Wallet", "syncStart", args);
    };

    syncStop(args, success, error) {
        exec(success, error, "Wallet", "syncStop", args);
    };

    reSync(args, success, error) {
        exec(success, error, "Wallet", "reSync", args);
    };

    getBalanceInfo(args, success, error) {
        exec(success, error, "Wallet", "getBalanceInfo", args);
    };

    getBalance(args, success, error) {
        exec(success, error, "Wallet", "getBalance", args);
    };

    getBalanceWithAddress(args, success, error) {
        exec(success, error, "Wallet", "getBalanceWithAddress", args);
    };

    createAddress(args, success, error) {
        exec(success, error, "Wallet", "createAddress", args);
    };

    getAllAddress(args, success, error) {
        _exec(success, error, "Wallet", "getAllAddress", args);
    };

    getAllPublicKeys(args, success, error) {
        _exec(success, error, "Wallet", "getAllPublicKeys", args);
    };

    createTransaction(args, success, error) {
        exec(success, error, "Wallet", "createTransaction", args);
    };

    getAllUTXOs(args, success, error) {
        _exec(success, error, "Wallet", "getAllUTXOs", args);
    };

    createConsolidateTransaction(args, success, error) {
        _exec(success, error, "Wallet", "createConsolidateTransaction", args);
    };

    signTransaction(args, success, error) {
        exec(success, error, "Wallet", "signTransaction", args);
    };

    getTransactionSignedInfo(args, success, error) {
        _exec(success, error, "Wallet", "getTransactionSignedInfo", args);
    };

    publishTransaction(args, success, error) {
        _exec(success, error, "Wallet", "publishTransaction", args);
    };

    getAllTransaction(args, success, error) {
        _exec(success, error, "Wallet", "getAllTransaction", args);
    };

    registerWalletListener(args, success, error) {
        exec(success, error, "Wallet", "registerWalletListener", args);
    };

    removeWalletListener(args, success, error) {
        exec(success, error, "Wallet", "removeWalletListener", args);
    };

    //SideChainSubWallet

    createWithdrawTransaction(args, success, error) {
        exec(success, error, "Wallet", "createWithdrawTransaction", args);
    };

    getGenesisAddress(args, success, error) {
        exec(success, error, "Wallet", "getGenesisAddress", args);
    };

    // IDChainSubWallet

    createIdTransaction(args, success, error) {
        exec(success, error, "Wallet", "createIdTransaction", args);
    };

    getAllDID(args, success, error) {
        exec(success, error, "Wallet", "getAllDID", args);
    };

    getAllCID(args, success, error) {
        exec(success, error, "Wallet", "getAllCID", args);
    };

    didSign(args, success, error) {
        exec(success, error, "Wallet", "didSign", args);
    };

    didSignDigest(args, success, error) {
        exec(success, error, "Wallet", "didSignDigest", args);
    };

    verifySignature(args, success, error) {
        exec(success, error, "Wallet", "verifySignature", args);
    };

    getPublicKeyDID(args, success, error) {
        exec(success, error, "Wallet", "getPublicKeyDID", args);
    };

    getPublicKeyCID(args, success, error) {
        exec(success, error, "Wallet", "getPublicKeyCID", args);
    };

    //MainchainSubWallet

    createDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createDepositTransaction", args);
    };

    getVotedProducerList(args, success, error) {
        exec(success, error, "Wallet", "getVotedProducerList", args);
    };

    getRegisteredProducerInfo(args, success, error) {
        exec(success, error, "Wallet", "getRegisteredProducerInfo", args);
    };

    createVoteProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteProducerTransaction", args);
    };

    generateProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateProducerPayload", args);
    };

    generateCancelProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateCancelProducerPayload", args);
    };

    createRegisterProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRegisterProducerTransaction", args);
    };

    createUpdateProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createUpdateProducerTransaction", args);
    };

    createCancelProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createCancelProducerTransaction", args);
    };

    createRetrieveDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRetrieveDepositTransaction", args);
    };

    getOwnerPublicKey(args, success, error) {
        exec(success, error, "Wallet", "getOwnerPublicKey", args);
    };

    //CR
    generateCRInfoPayload(args, success, error) {
        _exec(success, error, "Wallet", "generateCRInfoPayload", args);
    };

    generateUnregisterCRPayload(args, success, error) {
        exec(success, error, "Wallet", "generateUnregisterCRPayload", args);
    };

    createRegisterCRTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRegisterCRTransaction", args);
    };

    createUpdateCRTransaction(args, success, error) {
        exec(success, error, "Wallet", "createUpdateCRTransaction", args);
    };

    createUnregisterCRTransaction(args, success, error) {
        exec(success, error, "Wallet", "createUnregisterCRTransaction", args);
    };

    createRetrieveCRDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRetrieveCRDepositTransaction", args);
    };

    getRegisteredCRInfo(args, success, error) {
        exec(success, error, "Wallet", "getRegisteredCRInfo", args);
    };

    createVoteCRTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteCRTransaction", args);
    };

    getVotedCRList(args, success, error) {
        exec(success, error, "Wallet", "getVotedCRList", args);
    };

    createVoteCRCProposalTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteCRCProposalTransaction", args);
    };
    createImpeachmentCRCTransaction(args, success, error) {
        exec(success, error, "Wallet", "createImpeachmentCRCTransaction", args);
    };

    getVoteInfo(args, success, error) {
        exec(success, error, "Wallet", "getVoteInfo", args);
    };

    //Proposal
    proposalOwnerDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalOwnerDigest", args);
    };
    proposalCRCouncilMemberDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalCRCouncilMemberDigest", args);
    };
    calculateProposalHash(args, success, error) {
      exec(success, error, "Wallet", "calculateProposalHash", args);
    };
    createProposalTransaction(args, success, error) {
        exec(success, error, "Wallet", "createProposalTransaction", args);
    };
    proposalReviewDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalReviewDigest", args);
    };
    createProposalReviewTransaction(args, success, error) {
        exec(success, error, "Wallet", "createProposalReviewTransaction", args);
    };
    proposalTrackingOwnerDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalTrackingOwnerDigest", args);
    };
    proposalTrackingNewOwnerDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalTrackingNewOwnerDigest", args);
    };
    proposalTrackingSecretaryDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalTrackingSecretaryDigest", args);
    };
    createProposalTrackingTransaction(args, success, error) {
        exec(success, error, "Wallet", "createProposalTrackingTransaction", args);
    };
    proposalWithdrawDigest(args, success, error) {
        exec(success, error, "Wallet", "proposalWithdrawDigest", args);
    };
    createProposalWithdrawTransaction(args, success, error) {
        exec(success, error, "Wallet", "createProposalWithdrawTransaction", args);
    };
}

var walletManager = new WalletManagerImpl();
export = walletManager;