`timescale 1ns / 1ps

module tb_simple_dual_port_ram;

    // Testbench signals
    reg clk;
    reg we_a;

    reg [9:0] addr_a;
    reg [31:0] din_a;

    reg [9:0] addr_b;
    wire [31:0] dout_b;

    integer i;
    integer errors;

    reg [9:0] address_gen;
    reg [31:0] data_gen;

    // RAM instantiation 
    
    simple_dual_port_ram uut (
        .clk(clk),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .addr_b(addr_b),
        .dout_b(dout_b)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Initialize signals so they dont start as x unknown value 

        //so we deliberately start everything from a known state 
        clk = 0;
        we_a = 0;
        addr_a = 0;
        din_a = 0;
        addr_b = 0;
        errors = 0;

        #20;

        // ----------------------------------
        // WRITE LOOP: All 1024 addresses
        // ----------------------------------

        for (i = 0; i < 1024; i = i + 1) begin

            @(negedge clk);// wait for the falling edge so that at the next cycle like during next pos edge the inputs are ready 

            address_gen = i;
            data_gen = 32'h12340000 + i;
            //RAM[0] gets 12340000
                //RAM[1] gets 12340001
                   //  RAM[2] gets 12340002


            // 43-bit concatenation
            {we_a, addr_a, din_a} =
                {1'b1, address_gen, data_gen};

            @(posedge clk);
            #1;
            we_a = 0;

        end

        $display("Writing completed");


        // ----------------------------------
        // READ LOOP: Verify all addresses
        // ----------------------------------

        for (i = 0; i < 1024; i = i + 1) begin

            @(negedge clk);

            addr_b = i;

            @(posedge clk);
            #1;

            if (dout_b !== (32'h12340000 + i)) begin

                $display(
                    "FAIL: Address=%0d Data=%h",
                    addr_b, dout_b
                );

                errors = errors + 1;

            end

        end

        $display("Reading completed");


        // ----------------------------------
        // WRITE ENABLE TEST
        // ----------------------------------

        @(negedge clk);

        // Attempt write with enable = 0
        {we_a, addr_a, din_a} =
            {1'b0, 10'd10, 32'hFFFFFFFF};

        @(posedge clk);
        #1;

        // Read address 10 again
        @(negedge clk);
        addr_b = 10'd10;

        @(posedge clk);
        #1;

        if (dout_b === 32'h1234000A)
            $display("WRITE ENABLE TEST PASSED");
        else begin
            $display("WRITE ENABLE TEST FAILED");
            errors = errors + 1;
        end


        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL ERRORS = %0d", errors);

        $finish;

    end

endmodule
