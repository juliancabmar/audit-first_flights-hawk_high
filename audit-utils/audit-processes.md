# PROCESSES:

## Onboarding (using audit-notes.md template)
    while read the docs complete:
        Title
        Protocol about
        Roles
        Audit Scope
        Project Stats
        Compatibilities
            Solc versions
            Chains for production
            Tokens
        Know Issues

## Research Unknows
    Search in the docs and the imports unknows:
        EIP
        ERC
        Tokens
        Protocols
        Other Teory
    Add findings to:
        LIST::Unknows

## Search restrictions
    Add to LIST::Restrictions
        scope
        know issues

## Automated analisis
    compiler warning/errors (forge build)
    slitter (slither --include-paths "./src" .)
    aderyn (aderyn)

## Increase Kwnoledge
    for every LIST::Unknows
        search info
        understand it
        memorice it       

## Search the invariants
    add to LIST::Not Testeables Invariants
    add to LIST::Testebles Invariants

## Manual analisis
    For every contract/library/interface in file do:
        A: check unused for:
            imports
            types
            events
            errors
            modifiers
            state variables
            internal functions
        B: check not initialized for:
            state variables
            local variables
        C: taking in count LIST::Restrictions, LIST::Not Testeables Invariants and Compatibilities check:
            for exploits/bugs/inconsistencies on
                state variables
                constructor
                public functions
                external functions
                fallback function
                receive function

## Fuzzing
    Make a test for all on:
        LIST::Testeables Invariants

## Answering
    for every question on the code:
        if is a exploit/bug/inconsistency
            mark them @audit-[type] - [root cause] - [consecuences]
        else
            remove comment

## Analisis-Answer loop
    repeat Manual analisis::C <--> Answering until you feel satisfied

## Reporting
    configure the report






