module test::structs {

    use Symbols::{
    M1 as BLAH,
    M2::{
        SomeStruct,
        AnotherStruct,
    },
};
    struct Empty
    {

    }

    public struct Public
    {

    }

    struct Simple
    {
        f
      :
          u64
    }

    struct WithAbilities has
         key
     ,
       drop

    {
        f:   u64,
    }

    struct WithPostfixAbilities
        {
        f:   u64,
      }
     has
         key
     ,
       drop;



    struct TwoField {f1     :      u64,
        f2
      :
          u64
    }

    struct SimpleGeneric<T1  :    key,
       T2
    :
            store
       + drop + key
    ,
    >
    {
    }

    struct SimpleGenericWithAbilities
                <T1  :    key,
       T2
    :
            store
       + drop
    ,
    >
 has
         key
    {
    }

    struct OneLongGeneric<TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT  :    key>
    {
    }

    struct ThreeLongGenerics<phantom TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT1  :    key, TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT2  :    store, TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT3  :    drop>
    {
    }

    struct ThreeLongGenericsWithAbilitiesAndFields<TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT1  :    key, TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT2  :    store, TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT3  :    drop>
 has
         key
     ,
      drop
    {
        f1     :      u64,
        f2
      :
          u64
    }

    native struct NativeShort<T
       :  key
    > has
           key;

native struct NativeGenericWithAbilities
                <T1  :    key,
       T2
    :
            store
       + drop + key
    , T3
    >
 has
         key
     ,
      drop;

    struct PositionalEmpty
    (

        )

    struct PositionalFields
    (    Empty,
    u64
           )


    struct PositionalFieldsWithAbilities
    (    Empty,
    u64
           ) has key, store;


    struct PositionalFieldsLong
    (    PositionalFieldsWithAbilities,
    PositionalFieldsWithAbilities, PositionalFieldsWithAbilities, PositionalFieldsWithAbilities, PositionalFieldsWithAbilities, PositionalFieldsWithAbilities, PositionalFieldsWithAbilities
           )

            struct SomeOtherStruct has drop {
        some_field: u64,
    }

public fun test_long_fun_name_lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll(v: u64): SomeOtherStruct { SomeOtherStruct { some_field: v } }

// test fun sign whith no whitespace
    public fun multi_arg(p1:u64,p2:u64):u64{
        p1 + p2
    }


  // test two fun Close together without any blank lines
    public
  fun 
  multi_arg(
  p1/*cmt0*/: /*cmt1*/u64/*cmt2*/,/*cmt3*/
   p2: u64/*cmt4*/): /*cmt5*/
   u64
   {
        // Initialize variable y with value 100  
    let y: u64 =
     100;  
    // If y is less than or equal to 10, increment y by 1, otherwise set y to 10  
    let z = 
    if (y /*condition check*/ <= /*less than or equal to*/ 10) y = /*assignment*/ y + /*increment*/ 1 else y = /*assignment*/ 10;  

    p1 + p2
  }
}
