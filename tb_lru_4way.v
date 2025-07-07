`timescale 1ns/1ps
`include "cache_defs.vh"

module tb_lru_4way;

  reg clk, reset, update_en;
  reg [`INDEX_WIDTH-1:0] set_idx, query_idx;
  reg [1:0] accessed_way;
  wire [1:0] victim_way;

  lru_4way dut (
    .clk(clk),
    .reset(reset),
    .update_en(update_en),
    .set_idx(set_idx),
    .accessed_way(accessed_way),
    .query_idx(query_idx),
    .victim_way(victim_way)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Reference model for one set
  reg [1:0] ref_age[0:3];
  reg [1:0] expected_victim;
  integer i;

  task update_ref_model(input [1:0] accessed);
    reg [1:0] acc_age;
    begin
      acc_age = ref_age[accessed];
      for (i = 0; i < 4; i++) begin
        if (i == accessed)
          ref_age[i] = 0;
        else if (ref_age[i] < acc_age)
          ref_age[i] = ref_age[i] + 1;
      end
    end
  endtask

  task check_victim;
    begin
      for (i = 0; i < 4; i++)
        if (ref_age[i] == 2'd3)
          expected_victim = i[1:0];
      #1;
      if (victim_way !== expected_victim)
        $fatal("FAIL: Expected victim = %0d, Got = %0d", expected_victim, victim_way);
      else
        $display("PASS: Victim = %0d", victim_way);
    end
  endtask

  task run_test_for_set(input [`INDEX_WIDTH-1:0] test_set);
    begin
      set_idx = test_set;
      query_idx = test_set;
      $display("== Testing Set: %0d ==", test_set);

      // Test 1: Victim should be way 0
      reset = 1; update_en = 0; @(posedge clk); reset = 0;
      for (i = 0; i < 4; i++) ref_age[i] = i;
      accessed_way = 1; update_en = 1; update_ref_model(1); @(posedge clk);
      accessed_way = 2; update_ref_model(2); @(posedge clk);
      accessed_way = 3; update_ref_model(3); @(posedge clk);
      update_en = 0; @(posedge clk); check_victim();

      // Test 2: Victim should be way 1
      reset = 1; update_en = 0; @(posedge clk); reset = 0;
      for (i = 0; i < 4; i++) ref_age[i] = i;
      accessed_way = 0; update_en = 1; update_ref_model(0); @(posedge clk);
      accessed_way = 2; update_ref_model(2); @(posedge clk);
      accessed_way = 3; update_ref_model(3); @(posedge clk);
      update_en = 0; @(posedge clk); check_victim();

      // Test 3: Victim should be way 2
      reset = 1; update_en = 0; @(posedge clk); reset = 0;
      for (i = 0; i < 4; i++) ref_age[i] = i;
      accessed_way = 0; update_en = 1; update_ref_model(0); @(posedge clk);
      accessed_way = 1; update_ref_model(1); @(posedge clk);
      accessed_way = 3; update_ref_model(3); @(posedge clk);
      update_en = 0; @(posedge clk); check_victim();

      // Test 4: Victim should be way 3
      reset = 1; update_en = 0; @(posedge clk); reset = 0;
      for (i = 0; i < 4; i++) ref_age[i] = i;
      accessed_way = 0; update_en = 1; update_ref_model(0); @(posedge clk);
      accessed_way = 1; update_ref_model(1); @(posedge clk);
      accessed_way = 2; update_ref_model(2); @(posedge clk);
      update_en = 0; @(posedge clk); check_victim();
    end
  endtask

  initial begin
    $display("== LRU 4-Way Testbench with Multiple Sets Started ==");

    // VCD waveform output setup
    $dumpfile("lru_4way_waveform.vcd");  // name of VCD file
    $dumpvars(0, tb_lru_4way);           // dump all variables in this module

    reset = 1; update_en = 0; @(posedge clk); reset = 0;

    run_test_for_set(3);
    run_test_for_set(12);
    run_test_for_set(47);
    run_test_for_set(63);
    run_test_for_set(127);

    $display("== All Selected Set Tests Completed Successfully ==");
    $finish;
  end

endmodule
