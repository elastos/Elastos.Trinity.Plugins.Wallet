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
    print(args, success, error) {
        exec(success, error, "Wallet", "print", args);
    };

    recoverWallet(args, success, error) {
        exec(success, error, "Wallet", "recoverWallet", args);
    };

    createWallet(args, success, error) {
        exec(success, error, "Wallet", "createWallet", args);
    };

    start(args, success, error) {
        exec(success, error, "Wallet", "start", args);
    };

    stop(args, success, error) {
        exec(success, error, "Wallet", "stop", args);
    };

    createSubWallet(args, success, error) {
        exec(success, error, "Wallet", "createSubWallet", args);
    };

    recoverSubWallet(args, success, error) {
        exec(success, error, "Wallet", "createSubWallet", args);
    };

    createMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMasterWallet", args);
    };

    importWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithKeystore", args);
    };

    importWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithMnemonic", args);
    };

    exportWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithKeystore", args);
    };

    exportWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithMnemonic", args);
    };

    syncStart(args, success, error) {
        exec(success, error, "Wallet", "syncStart", args);
    };

    syncStop(args, success, error) {
        exec(success, error, "Wallet", "syncStop", args);
    };

    getBalanceInfo(args, success, error) {
        exec(success, error, "Wallet", "getBalanceInfo", args);
    };

    getBalance(args, success, error) {
        exec(success, error, "Wallet", "getBalance", args);
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

    getBalanceWithAddress(args, success, error) {
        exec(success, error, "Wallet", "getBalanceWithAddress", args);
    };

    // generateMultiSignTransaction(args, success, error) {
    //     exec(success, error, "Wallet", "generateMultiSignTransaction", args);
    // };

    // createMultiSignAddress(args, success, error) {
    //     exec(success, error, "Wallet", "createMultiSignAddress", args);
    // };

    getAllTransaction(args, success, error) {
        _exec(success, error, "Wallet", "getAllTransaction", args);
    };

    getAllMasterWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllMasterWallets", args);
    };

    registerWalletListener(args, success, error) {
        exec(success, error, "Wallet", "registerWalletListener", args);
    };

    isAddressValid(args, success, error) {
        exec(success, error, "Wallet", "isAddressValid", args);
    };

    generateMnemonic(args, success, error) {
        exec(success, error, "Wallet", "generateMnemonic", args);
    };

    getSupportedChains(args, success, error) {
        exec(success, error, "Wallet", "getSupportedChains", args);
    };

    getAllSubWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllSubWallets", args);
    };

    changePassword(args, success, error) {
        exec(success, error, "Wallet", "changePassword", args);
    };

    createTransaction(args, success, error) {
        exec(success, error, "Wallet", "createTransaction", args);
    };

    createDID(args, success, error) {
        exec(success, error, "Wallet", "createDID", args);
    };

    getDIDList(args, success, error) {
        exec(success, error, "Wallet", "getDIDList", args);
    };

    destoryDID(args, success, error) {
        exec(success, error, "Wallet", "destoryDID", args);
    };

    destroyWallet(args, success, error) {
        exec(success, error, "Wallet", "destroyWallet", args);
    };

    createIdTransaction(args, success, error) {
        exec(success, error, "Wallet", "createIdTransaction", args);
    };

    getResolveDIDInfo(args, success, error) {
        exec(success, error, "Wallet", "getResolveDIDInfo", args);
    };

    getAllDID(args, success, error) {
        exec(success, error, "Wallet", "getAllDID", args);
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

    generateDIDInfoPayload(args, success, error) {
        exec(success, error, "Wallet", "generateDIDInfoPayload", args);
    };

    createDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createDepositTransaction", args);
    };

    createWithdrawTransaction(args, success, error) {
        exec(success, error, "Wallet", "createWithdrawTransaction", args);
    };

    getGenesisAddress(args, success, error) {
        exec(success, error, "Wallet", "getGenesisAddress", args);
    };

    createMultiSignMasterWalletWithPrivKey(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithPrivKey", args);

    };

    createMultiSignMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWallet", args);

    };

    getMasterWalletBasicInfo(args, success, error) {
        _exec(success, error, "Wallet", "getMasterWalletBasicInfo", args);
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

    publishTransaction(args, success, error) {
        _exec(success, error, "Wallet", "publishTransaction", args);
    };

    createMultiSignMasterWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithMnemonic", args);
    };

    removeWalletListener(args, success, error) {
        exec(success, error, "Wallet", "removeWalletListener", args);
    };

    // getMultiSignPubKeyWithMnemonic(args, success, error) {
    //     exec(success, error, "Wallet", "getMultiSignPubKeyWithMnemonic", args);
    // };

    // getMultiSignPubKeyWithPrivKey(args, success, error) {
    //     exec(success, error, "Wallet", "getMultiSignPubKeyWithPrivKey", args);
    // };

    getTransactionSignedSigners(args, success, error) {
        _exec(success, error, "Wallet", "getTransactionSignedSigners", args);
    };

    // importWalletWithOldKeystore(args, success, error) {
    //     exec(success, error, "Wallet", "importWalletWithOldKeystore", args);
    // };

    getVersion(args, success, error) {
        exec(success, error, "Wallet", "getVersion", args);
    };

    destroySubWallet(args, success, error) {
        exec(success, error, "Wallet", "destroySubWallet", args);
    };

    getVotedProducerList(args, success, error) {
        exec(success, error, "Wallet", "getVotedProducerList", args);
    };

    createVoteProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteProducerTransaction", args);
    };

    createCancelProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createCancelProducerTransaction", args);
    };

    getRegisteredProducerInfo(args, success, error) {
        exec(success, error, "Wallet", "getRegisteredProducerInfo", args);
    };

    createRegisterProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRegisterProducerTransaction", args);
    };

    generateProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateProducerPayload", args);
    };

    generateCancelProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateCancelProducerPayload", args);
    };

    getOwnerPublicKey(args, success, error) {
        exec(success, error, "Wallet", "getOwnerPublicKey", args);
    };

    createRetrieveDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRetrieveDepositTransaction", args);
    };

    createUpdateProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createUpdateProducerTransaction", args);
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

    createVoteCRTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteCRTransaction", args);
    };

    getVotedCRList(args, success, error) {
        exec(success, error, "Wallet", "getVotedCRList", args);
    };

    getRegisteredCRInfo(args, success, error) {
        exec(success, error, "Wallet", "getRegisteredCRInfo", args);
    };

    getVoteInfo(args, success, error) {
        exec(success, error, "Wallet", "getVoteInfo", args);
    };

    //Proposal
    sponsorProposalDigest(args, success, error) {
        exec(success, error, "Wallet", "sponsorProposalDigest", args);
    };
    CRSponsorProposalDigest(args, success, error) {
        exec(success, error, "Wallet", "CRSponsorProposalDigest", args);
    };
    createCRCProposalTransaction(args, success, error) {
        exec(success, error, "Wallet", "createCRCProposalTransaction", args);
    };
    generateCRCProposalReview(args, success, error) {
        exec(success, error, "Wallet", "generateCRCProposalReview", args);
    };
    createCRCProposalReviewTransaction(args, success, error) {
        exec(success, error, "Wallet", "createCRCProposalReviewTransaction", args);
    };
    createVoteCRCProposalTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteCRCProposalTransaction", args);
    };
    createImpeachmentCRCTransaction(args, success, error) {
        exec(success, error, "Wallet", "createImpeachmentCRCTransaction", args);
    };
    leaderProposalTrackDigest(args, success, error) {
        exec(success, error, "Wallet", "leaderProposalTrackDigest", args);
    };
    newLeaderProposalTrackDigest(args, success, error) {
        exec(success, error, "Wallet", "newLeaderProposalTrackDigest", args);
    };
    secretaryGeneralProposalTrackDigest(args, success, error) {
        exec(success, error, "Wallet", "secretaryGeneralProposalTrackDigest", args);
    };
    createProposalTrackingTransaction(args, success, error) {
        exec(success, error, "Wallet", "createProposalTrackingTransaction", args);
    };
}

var walletManager = new WalletManagerImpl();
export = walletManager;