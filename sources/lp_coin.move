module learn_move::lp_coin_managed_account {
    use std::signer;
    use std::type_info;
    use std::option;
    use aptos_framework::account::{Self, SignerCapability};
    use learn_move::lp_coin_managed_account;

    struct LPCoin<phantom A, phantom B> has store {}

    public entry fun create_pool<CoinA, CoinB>(provider: &signer) {

        let managed_account = lp_coin_managed_account::get_signer();

        // This will not pass because there is a difference between the address of the LPCoin struct and the address of the managed_account.
        coin::initialize<LPCoin<CoinA, CoinB>>(
            managed_account,
            b"test LP Coin",
            b"TLPC",
            8,
            true
        );

        managed_coin::register<LPCoin<CoinA, CoinB>>(provider);

        // managed_coin::mint<LPCoin<CoinA, CoinB>>(
        //     managed_account,
        //     signer::address_of(provider),
        //     lp_coin_amount,
        // )
    }
}
