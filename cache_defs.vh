// cache_defs.vh
`define INDEX_WIDTH     7                    // log2(128 sets)
`define SETS            128                  // Number of sets
`define ASSOCIATIVITY   4                    // 4-way associative
`define TAG_WIDTH       8                    // Adjust based on ADDR_WIDTH - INDEX_WIDTH
`define WORD_WIDTH      32                   // 32-bit data
`define ADDR_WIDTH      (`TAG_WIDTH + `INDEX_WIDTH)
