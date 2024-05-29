// /// Incentive-associated parameters and data structures.
// ///
// /// Contains hard-coded "genesis parameters" that are are set
// /// upon module publication per `init_module()`, and which can be
// /// updated later per `set_incentive_parameters()`.
// ///
// /// # General overview sections
// ///
// /// [Incentive model](#incentive-model)
// ///
// /// [Functions](#functions)
// ///
// /// * [View functions](#view-functions)
// /// * [Public getters](#public-getters)
// /// * [Other public functions](#other-public-functions)
// /// * [Public entry functions](#public-entry-functions)
// /// * [Public friend functions](#public-friend-functions)
// ///
// /// [Dependency charts](#dependency-charts)
// ///
// /// * [Incentive parameters setters](#incentive-parameter-setters)
// /// * [Econia fee account operations](#econia-fee-account-operations)
// /// * [Registrant operations](#registrant-operations)
// /// * [Integrator operations](#integrator-operations)
// /// * [Match operations](#match-operations)
// ///
// /// [Complete DocGen index](#complete-docgen-index)
// ///
// /// # Incentive model
// ///
// /// As a permissionless system, Econia mitigates denial-of-service (DoS)
// /// attacks by charging utility coins for assorted operations. Econia
// /// also charges taker fees, denominated in the quote coin for a given
// /// market, which are distributed between integrators and Econia. The
// /// share of taker fees distributed between an integrator and Econia,
// /// for a given market, is determined by the "tier" to which the
// /// integrator has "activated" their fee store: when the matching engine
// /// fills a taker order, the integrator who facilitated the transaction
// /// has a portion of taker fees deposited to their fee store, and Econia
// /// gets the rest, with the split thereof determined by the integrator's
// /// fee store tier for the given market. Econia does not charge maker
// /// fees.
// ///
// /// Hence Econia involves 5 major incentive parameters, defined at
// /// `IncentiveParameters`:
// ///
// /// 1. The utility coin type.
// /// 2. The fee, denominated in the utility coin, to register a market.
// /// 3. The fee, denominated in the utility coin, to register as an
// ///    underwriter for a generic market.
// /// 4. The fee, denominated in the utility coin, to register as
// ///    custodian.
// /// 5. The taker fee divisor, denoting the portion of quote coins for a
// ///    particular trade, paid by the taker, to be split between the
// ///    integrator who facilitated the trade, and Econia.
// ///
// /// `IncentiveParameters` also includes a vector of
// /// `IntegratorFeeStoreTierParameters`, which define 3 parameters per
// /// tier:
// ///
// /// 1. The taker fee divisor, denoting the portion of quote coins for a
// ///    particular trade, paid by the taker, to be collected by an
// ///    integrator whose fee store is activated to the given tier.
// /// 2. The cumulative fee, denominated in the utility coin, to activate
// ///    to the given tier.
// /// 3. The fee, denominated in the utility coin, to withdraw quote coins
// ///    collected as fees, from an integrator's fee store.
// ///
// /// Upon module publication, the Econia "genesis parameters" are
// /// set according to hard-coded values via `init_module()`. Later, the
// /// parameters can be updated via `set_incentive_parameters()`, so long
// /// as the number of tiers is not reduced and other minor restrictions
// /// are met. For an implementation-exact description of restrictions and
// /// corresponding abort codes, see:
// ///
// /// * `set_incentive_parameters()`
// /// * `set_incentive_parameters_range_check_inputs()`
// /// * `set_incentive_parameters_parse_tiers_vector()`
// ///
// /// # Functions
// ///
// /// ## View functions
// ///
// /// * `get_cost_to_upgrade_integrator_fee_store_view()`
// /// * `get_custodian_registration_fee()`
// /// * `get_fee_share_divisor()`
// /// * `get_integrator_withdrawal_fee_view()`
// /// * `get_market_registration_fee()`
// /// * `get_n_fee_store_tiers()`
// /// * `get_taker_fee_divisor()`
// /// * `get_tier_activation_fee()`
// /// * `get_tier_withdrawal_fee()`
// /// * `get_underwriter_registration_fee()`
// /// * `is_utility_coin_type()`
// ///
// /// ## Public getters
// ///
// /// * `get_cost_to_upgrade_integrator_fee_store()`
// /// * `get_integrator_withdrawal_fee()`
// /// * `verify_utility_coin_type()`
// ///
// /// ## Other public functions
// ///
// /// * `upgrade_integrator_fee_store()`
// /// * `withdraw_econia_fees()`
// /// * `withdraw_econia_fees_all()`
// /// * `withdraw_integrator_fees()`
// /// * `withdraw_utility_coins()`
// /// * `withdraw_utility_coins_all()`
// ///
// /// ## Public entry functions
// ///
// /// * `update_incentives()`
// /// * `upgrade_integrator_fee_store_via_coinstore()`
// /// * `withdraw_econia_fees_all_to_coin_store()`
// /// * `withdraw_econia_fees_to_coin_store()`
// /// * `withdraw_integrator_fees_via_coinstores()`
// /// * `withdraw_utility_coins_all_to_coin_store()`
// /// * `withdraw_utility_coins_to_coin_store()`
// ///
// /// ## Public friend functions
// ///
// /// * `assess_taker_fees()`
// /// * `calculate_max_quote_match()`
// /// * `deposit_custodian_registration_utility_coins()`
// /// * `deposit_market_registration_utility_coins()`
// /// * `deposit_underwriter_registration_utility_coins()`
// /// * `register_econia_fee_store_entry()`
// /// * `register_integrator_fee_store()`
// ///
// /// # Dependency charts
// ///
// /// The below dependency charts use `mermaid.js` syntax, which can be
// /// automatically rendered into a diagram (depending on the browser)
// /// when viewing the documentation file generated from source code. If
// /// a browser renders the diagrams with coloring that makes it difficult
// /// to read, try a different browser.
// ///
// /// ## Incentive parameter setters
// ///
// /// ```mermaid
// ///
// /// flowchart LR
// ///
// /// update_incentives --> set_incentive_parameters
// /// init_module --> set_incentive_parameters
// /// set_incentive_parameters -->
// ///     set_incentive_parameters_parse_tiers_vector
// /// set_incentive_parameters --> resource_account::get_signer
// /// set_incentive_parameters -->
// ///     set_incentive_parameters_range_check_inputs
// /// set_incentive_parameters --> init_utility_coin_store
// /// set_incentive_parameters --> get_n_fee_store_tiers
// ///
// /// ```
// ///
// /// ## Econia fee account operations
// ///
// /// ```mermaid
// ///
// /// flowchart LR
// ///
// /// deposit_utility_coins --> resource_account::get_address
// /// deposit_utility_coins --> range_check_coin_merge
// /// deposit_utility_coins_verified --> verify_utility_coin_type
// /// deposit_utility_coins_verified --> deposit_utility_coins
// /// withdraw_utility_coins --> withdraw_utility_coins_internal
// /// withdraw_utility_coins_all --> withdraw_utility_coins_internal
// /// withdraw_utility_coins_all_to_coin_store -->
// ///     withdraw_utility_coins_to_coin_store_internal
// /// withdraw_utility_coins_to_coin_store -->
// ///     withdraw_utility_coins_to_coin_store_internal
// /// withdraw_utility_coins_to_coin_store_internal -->
// ///     withdraw_utility_coins_internal
// /// withdraw_utility_coins_internal --> resource_account::get_address
// /// withdraw_econia_fees --> withdraw_econia_fees_internal
// /// withdraw_econia_fees_all --> withdraw_econia_fees_internal
// /// withdraw_econia_fees_internal --> resource_account::get_address
// /// withdraw_econia_fees_all_to_coin_store -->
// ///     withdraw_econia_fees_to_coin_store_internal
// /// withdraw_econia_fees_to_coin_store -->
// ///     withdraw_econia_fees_to_coin_store_internal
// /// withdraw_econia_fees_to_coin_store_internal -->
// ///     withdraw_econia_fees_internal
// /// register_econia_fee_store_entry --> resource_account::get_signer
// ///
// /// ```
// ///
// /// ## Registrant operations
// ///
// /// ```mermaid
// ///
// /// flowchart LR
// ///
// /// deposit_custodian_registration_utility_coins -->
// ///     get_custodian_registration_fee
// /// deposit_custodian_registration_utility_coins -->
// ///     deposit_utility_coins_verified
// /// deposit_underwriter_registration_utility_coins -->
// ///     get_underwriter_registration_fee
// /// deposit_underwriter_registration_utility_coins --->
// ///     deposit_utility_coins_verified
// /// deposit_market_registration_utility_coins -->
// ///     deposit_utility_coins_verified
// /// deposit_market_registration_utility_coins -->
// ///     get_market_registration_fee
// ///
// /// ```
// ///
// /// ## Integrator operations
// ///
// /// ```mermaid
// ///
// /// flowchart LR
// ///
// /// withdraw_integrator_fees_via_coinstores -->
// ///     get_integrator_withdrawal_fee
// /// get_integrator_withdrawal_fee --> get_tier_withdrawal_fee
// /// withdraw_integrator_fees_via_coinstores --> withdraw_integrator_fees
// /// withdraw_integrator_fees --> get_tier_withdrawal_fee
// /// withdraw_integrator_fees --> deposit_utility_coins_verified
// /// register_integrator_fee_store ---> deposit_utility_coins_verified
// /// register_integrator_fee_store --> get_tier_activation_fee
// /// upgrade_integrator_fee_store_via_coinstore -->
// ///     upgrade_integrator_fee_store
// /// upgrade_integrator_fee_store_via_coinstore -->
// ///     get_cost_to_upgrade_integrator_fee_store
// /// upgrade_integrator_fee_store --> deposit_utility_coins_verified
// /// upgrade_integrator_fee_store -->
// ///     get_cost_to_upgrade_integrator_fee_store
// /// get_cost_to_upgrade_integrator_fee_store -->
// ///     get_cost_to_upgrade_integrator_fee_store_view
// /// get_integrator_withdrawal_fee --> get_integrator_withdrawal_fee_view
// ///
// /// ```
// ///
// /// ## Match operations
// ///
// /// ```mermaid
// ///
// /// flowchart LR
// ///
// /// assess_taker_fees --> get_fee_share_divisor
// /// assess_taker_fees --> get_taker_fee_divisor
// /// assess_taker_fees --> resource_account::get_address
// /// assess_taker_fees --> range_check_coin_merge
// ///
// /// ```
// ///
// /// # Complete DocGen index
// ///
// /// The below index is automatically generated from source code:
// module TestFunFormat {
//     fun f1_fun()/*fun2*/ acquires LongName1, LongName2, LongName3, LongName4, LongName5, LongName6, LongName7, LongName8, LongName9, LongName10 {
//     }

//     //     fun longfffffffffffff10() acquires LongName1, 
//     // LongName2, LongName3, LongName4, 
//     // LongName5, LongName6, LongName7, 
//     // LongName8, LongName9, LongName10 {
//     // }

//             fun f(x: u64): u64 {
//         if (x == 1) {
//             if (x == 11) {
//                 11
//             } else if (x == 12) {
//                 12
//             } else if (x == 13) {
//                 13
//             } else {
//                 14
//             }
//         } else if (x == 2) {
//             if (x == 21) {
//                 21
//             } else if (x == 22) {
//                 22
//             } else if (x == 23) {
//                 23
//             } else {
//                 24
//             }
//         } else if (x == 3) {
//             4
//         } else {
//             if (x == 51) {
//                 51
//             } else if (x == 52) {
//                 52
//             } else if (x == 53) {
//                 53
//             } else {
//                 54
//             }
//         }
//     }
// }

address 0x2 {

module Token {

    struct Coin<AssetType: copy + drop> has store {
        type: AssetType,
        value: u64,
    }

    // control the minting/creation in the defining module of `ATy`
    public fun create<ATy: copy + drop + store>(type: ATy, value: u64): Coin<ATy> {
        Coin { type, value }
    }

    public fun value<ATy: copy + drop + store>(coin: &Coin<ATy>): u64 {
        coin.value
    }

}

}

address 0xB055 {

module OneToOneMarket {
    use std::signer;
    use 0x2::Token;

    struct Pool<AssetType: copy + drop> has key {
        coin: Token::Coin<AssetType>,
    }

    struct DepositRecord<phantom InputAsset: copy + drop, phantom OutputAsset: copy + drop> has key {
        record: u64,
    }

    struct BorrowRecord<phantom InputAsset: copy + drop, phantom OutputAsset: copy + drop> has key {
        record: u64,
    }

    struct Price<phantom InputAsset: copy + drop, phantom OutputAsset: copy + drop> has key {
        price: u64,
    }

    fun max_borrow_amount<In: copy + drop + store, Out: copy + drop + store>(account: &signer): u64
        acquires Price, Pool, DepositRecord, BorrowRecord
    {
        let input_deposited = deposited_amount<In, Out>(account);
        let output_deposited = borrowed_amount<In, Out>(account);

        let input_into_output =
            input_deposited * borrow_global<Price<In, Out>>(@0xB055).price;
        let max_output =
            if (input_into_output < output_deposited) 0
            else (input_into_output - output_deposited);
        let available_output = {
            let pool = borrow_global<Pool<Out>>(@0xB055);
            Token::value(&pool.coin)
        };
        if (max_output < available_output) max_output else available_output

    }

    fun borrowed_amount<In: copy + drop + store, Out: copy + drop + store>(account: &signer): u64
        acquires BorrowRecord
    {
        let sender = signer::address_of(account);
        if (!exists<BorrowRecord<In, Out>>(sender)) return 0;
        borrow_global<BorrowRecord<In, Out>>(sender).record
    }
}

}

address 0x70DD {

module ToddNickels {
    use 0x2::Token;
    use std::signer;

    struct T has copy, drop, store {}

    struct Wallet has key {
        nickels: Token::Coin<T>,
    }

    public fun init(account: &signer) {
        assert!(signer::address_of(account) == @0x70DD, 42);
        move_to(account, Wallet { nickels: Token::create(T{}, 0) })
    }


}

}

address 0x661 {
/**
Allow multiple delegators to participate in the same stake pool in order to collect the minimum
stake required to join the validator set. Delegators are rewarded out of the validator rewards
proportionally to their stake and provided the same stake-management API as the stake pool owner.

The main accounting logic in the delegation pool contract handles the following:
1. Tracks how much stake each delegator owns, privately deposited as well as earned.
Accounting individual delegator stakes is achieved through the shares-based pool defined at
<code>aptos_std::pool_u64</code>, hence delegators own shares rather than absolute stakes into the delegation pool.
2. Tracks rewards earned by the stake pool, implicitly by the delegation one, in the meantime
and distribute them accordingly.
3. Tracks lockup cycles on the stake pool in order to separate inactive stake (not earning rewards)
from pending_inactive stake (earning rewards) and allow its delegators to withdraw the former.
4. Tracks how much commission fee has to be paid to the operator out of incoming rewards before
distributing them to the internal pool_u64 pools.

In order to distinguish between stakes in different states and route rewards accordingly,
separate pool_u64 pools are used for individual stake states:
1. one of <code>active</code> + <code>pending_active</code> stake
2. one of <code>inactive</code> stake FOR each past observed lockup cycle (OLC) on the stake pool
3. one of <code>pending_inactive</code> stake scheduled during this ongoing OLC

As stake-state transitions and rewards are computed only at the stake pool level, the delegation pool
gets outdated. To mitigate this, at any interaction with the delegation pool, a process of synchronization
to the underlying stake pool is executed before the requested operation itself.

At synchronization:
 - stake deviations between the two pools are actually the rewards produced in the meantime.
 - the commission fee is extracted from the rewards, the remaining stake is distributed to the internal
pool_u64 pools and then the commission stake used to buy shares for operator.
 - if detecting that the lockup expired on the stake pool, the delegation pool will isolate its
pending_inactive stake (now inactive) and create a new pool_u64 to host future pending_inactive stake
scheduled this newly started lockup.
Detecting a lockup expiration on the stake pool resumes to detecting new inactive stake.

Accounting main invariants:
 - each stake-management operation (add/unlock/reactivate/withdraw) and operator change triggers
the synchronization process before executing its own function.
 - each OLC maps to one or more real lockups on the stake pool, but not the opposite. Actually, only a real
lockup with 'activity' (which inactivated some unlocking stake) triggers the creation of a new OLC.
 - unlocking and/or unlocked stake originating from different real lockups are never mixed together into
the same pool_u64. This invalidates the accounting of which rewards belong to whom.
 - no delegator can have unlocking and/or unlocked stake (pending withdrawals) in different OLCs. This ensures
delegators do not have to keep track of the OLCs when they unlocked. When creating a new pending withdrawal,
the existing one is executed (withdrawn) if is already inactive.
 - <code>add_stake</code> fees are always refunded, but only after the epoch when they have been charged ends.
 - withdrawing pending_inactive stake (when validator had gone inactive before its lockup expired)
does not inactivate any stake additional to the requested one to ensure OLC would not advance indefinitely.
 - the pending withdrawal exists at an OLC iff delegator owns some shares within the shares pool of that OLC.

Example flow:
<ol>
<li>A node operator creates a delegation pool by calling
<code>initialize_delegation_pool</code> and sets
its commission fee to 0% (for simplicity). A stake pool is created with no initial stake and owned by
a resource account controlled by the delegation pool.</li>
<li>Delegator A adds 100 stake which is converted to 100 shares into the active pool_u64</li>
<li>Operator joins the validator set as the stake pool has now the minimum stake</li>
<li>The stake pool earned rewards and now has 200 active stake. A's active shares are worth 200 coins as
the commission fee is 0%.</li>
<li></li>
<ol>
    <li>A requests <code>unlock</code> for 100 stake</li>
    <li>Synchronization detects 200 - 100 active rewards which are entirely (0% commission) added to the active pool.</li>
    <li>100 coins = (100 * 100) / 200 = 50 shares are redeemed from the active pool and exchanged for 100 shares
into the pending_inactive one on A's behalf</li>
</ol>
<li>Delegator B adds 200 stake which is converted to (200 * 50) / 100 = 100 shares into the active pool</li>
<li>The stake pool earned rewards and now has 600 active and 200 pending_inactive stake.</li>
<li></li>
<ol>
    <li>A requests <code>reactivate_stake</code> for 100 stake</li>
    <li>
    Synchronization detects 600 - 300 active and 200 - 100 pending_inactive rewards which are both entirely
    distributed to their corresponding pools
    </li>
    <li>
    100 coins = (100 * 100) / 200 = 50 shares are redeemed from the pending_inactive pool and exchanged for
    (100 * 150) / 600 = 25 shares into the active one on A's behalf
    </li>
</ol>
<li>The lockup expires on the stake pool, inactivating the entire pending_inactive stake</li>
<li></li>
<ol>
    <li>B requests <code>unlock</code> for 100 stake</li>
    <li>
    Synchronization detects no active or pending_inactive rewards, but 0 -> 100 inactive stake on the stake pool,
    so it advances the observed lockup cycle and creates a pool_u64 for the new lockup, hence allowing previous
    pending_inactive shares to be redeemed</li>
    <li>
    100 coins = (100 * 175) / 700 = 25 shares are redeemed from the active pool and exchanged for 100 shares
    into the new pending_inactive one on B's behalf
    </li>
</ol>
<li>The stake pool earned rewards and now has some pending_inactive rewards.</li>
<li></li>
<ol>
    <li>A requests <code>withdraw</code> for its entire inactive stake</li>
    <li>
    Synchronization detects no new inactive stake, but some pending_inactive rewards which are distributed
    to the (2nd) pending_inactive pool
    </li>
    <li>
    A's 50 shares = (50 * 100) / 50 = 100 coins are redeemed from the (1st) inactive pool and 100 stake is
    transferred to A
    </li>
</ol>
</ol>
 */
module lll {
    fun smart_vector_test_zip_ref() {
        let v1 = make_smart_vector(100);
        let v2 = make_smart_vector(100);
        let s = 0;
        V::zip_ref(&v1, &v2,|e1, e2| s = s+*e1 / *e2);
        assert!(s == 100, 0);
        V::destroy(v1);
        V::destroy(v2);
    }
}

script {
fun main() {  
      let y:u64=100    ; let x: u64 = 0;// Define an unsigned 64-bit integer variable y and assign it a value of 100  
    let z = /* you can comment everywhere */if (y <= 10) { // If y is less than or equal to 10  
            y = y + 1; // Increment y by 1  
    } else {  
        y = /* you can comment everywhere */10; // Otherwise, set y to 10  
    };
       let z2 = if 
       (x = 0){ // If x equals 0
      x = x +   2;  // x increases by 2
    }    else {
      x = 10;   // Otherwise, set y to 10
    };
    /*
    aa
    bb
    */
}
}

}


address 0x662 {
    module lll {

            struct SomeOtherStruct has drop {
        some_field: u64,
    }

public fun test_long_fun_name_lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll(v: u64): SomeOtherStruct { SomeOtherStruct { some_field: v } }

// test fun sign whith no whitespace
    public fun multi_arg(p1:u64,p2:u64):u64{
        p1 + p2
    }

    
fun main() {  
    let y: u64 = 100; // Define an unsigned 64-bit integer variable y and assign it a value of 100  
    let /*comment*/z/*comment*/ = if/*comment*/ (/*comment*/y <= /*comment*/10/*comment*/) { // If y is less than or equal to 10  
        y = y + 1; // Increment y by 1  
    }/*comment*/ else /*comment*/{  
        y = 10; // Otherwise, set y to 10  
    };  
}
    }
script {fun main() {  
    // Initialize variable y with value 100  
    let y: u64 = 100;  
    // If y is less than or equal to 10, increment y by 1, otherwise set y to 10  
    let z = if (y /*condition check*/ <= /*less than or equal to*/ 10) y = /*assignment*/ y + /*increment*/ 1 else y = /*assignment*/ 10;  
}}



}