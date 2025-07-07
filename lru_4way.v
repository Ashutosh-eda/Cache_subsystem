
`include "cache_defs.vh"

module lru_4way (
  input  wire                     clk,
  input  wire                     reset,
  input  wire                     update_en,
  input  wire [`INDEX_WIDTH-1:0] set_idx,
  input  wire [1:0]              accessed_way,
  input  wire [`INDEX_WIDTH-1:0] query_idx,
  output reg  [1:0]              victim_way
);

  reg [1:0] age [`SETS-1:0][`ASSOCIATIVITY-1:0];
  integer i;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      integer s, w;
      for (s = 0; s < `SETS; s = s + 1)
        for (w = 0; w < `ASSOCIATIVITY; w = w + 1)
          age[s][w] <= w[1:0]; // MRU=0, LRU=3
    end else if (update_en) begin
      for (i = 0; i < `ASSOCIATIVITY; i = i + 1) begin
        if (i == accessed_way)
          age[set_idx][i] <= 2'd0;
        else if (age[set_idx][i] < age[set_idx][accessed_way])
          age[set_idx][i] <= age[set_idx][i] + 1;
      end
    end
  end

  always @(*) begin
    victim_way = 2'd3;
    if (age[query_idx][0] == 2'd3) victim_way = 2'd0;
    else if (age[query_idx][1] == 2'd3) victim_way = 2'd1;
    else if (age[query_idx][2] == 2'd3) victim_way = 2'd2;
  end

endmodule
