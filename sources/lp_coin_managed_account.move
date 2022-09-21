module learn_move::lp_coin_managed_account {
    use std::signer;
    use std::type_info;
    use std::option;
    use aptos_framework::account::{Self, SignerCapability};

    friend learn_move::lp_coin;

    struct LpCoinManagedAccountCap has key {
        adr: address,
        cap: SignerCapability,
    }

    struct MyModuleResource has key {
        resource_signer_cap: option::Option<SignerCapability>
    }

    public fun initialize(owner: &signer, seed: vector<u8>) {
        assert!(signer::address_of(owner) == @module_owner, 0);

        let (escrow_signer, signer_cap) = account::create_resource_account(
            owner,
            seed,
        );

        move_to(
            owner,
            LpCoinManagedAccountCap {
                adr: signer::address_of(&escrow_signer),
                cap: signer_cap
            }
        );
    }

    public(friend) fun get_signer(): signer acquires LpCoinManagedAccountCap {
        account::create_signer_with_capability(&borrow_global<LpCoinManagedAccountCap>(@module_owner).cap)
    }

    public fun provide_signer_capability(resource_signer_cap: SignerCapability) acquires MyModuleResource {
        let account_addr = account::get_signer_capability_address(&resource_signer_cap);
        let resource_addr = type_info::account_address(&type_info::type_of<MyModuleResource>());
        assert!(account_addr == resource_addr, 1);
        let modules = borrow_global_mut<MyModuleResource>(account_addr);
        modules.resource_signer_cap = option::some(resource_signer_cap);
    }
}
