`timescale 1ns / 1ps

module tb_simple_dual_port_ram;

   


    reg clk;

    reg        we_a;
    reg [9:0]  addr_a;
    reg [31:0] din_a;

    reg [9:0]  addr_b;

    wire [31:0] dout_b;


  
   

    simple_dual_port_ram uut (
        .clk    (clk),
        .we_a   (we_a),
        .addr_a (addr_a),
        .din_a  (din_a),
        .addr_b (addr_b),
        .dout_b (dout_b)
    );




    always #5 clk = ~clk;




    task write_ram;

        input [9:0] address;
        input [31:0] data;

        begin

      
           @(negedge clk);//so that inputs are ready during the design code and not chnaging at the very instant when the ram wants to access it ,"We use the negative clock edge in the testbench to apply inputs before the RAM's positive clock edge. However, in actual synchronous hardware, circuits can use the same positive clock edge, provided setup and hold timing requirements are satisfied

            we_a   = 1'b1;
            addr_a = address;
            din_a  = data;

  
            @(posedge clk);

            #1;
            we_a = 1'b0;

        end

    endtask




    task read_check;

        input [9:0] address;
        input [31:0] expected_data;

        begin

     
            @(negedge clk);

            addr_b = address;

    
            @(posedge clk);

            #1;

            // Check output
            if (dout_b === expected_data)
                $display(
                    "PASS: Address %0d, Expected = %h, Got = %h",
                    address,
                    expected_data,
                    dout_b
                );
            else
                $display(
                    "FAIL: Address %0d, Expected = %h, Got = %h",
                    address,
                    expected_data,
                    dout_b
                );

        end

    endtask




    initial begin


        clk    = 1'b0;

        we_a   = 1'b0;
        addr_a = 10'd0;
        din_a  = 32'd0;

        addr_b = 10'd0;



        #20;




        write_ram(
            10'd10,
            32'h12345678
        );

        write_ram(
            10'd20,
            32'hDEADBEEF
        );

        write_ram(
            10'd30,
            32'hCAFEBABE
        );




        read_check(
            10'd10,
            32'h12345678
        );

        read_check(
            10'd20,
            32'hDEADBEEF
        );

        read_check(
            10'd30,
            32'hCAFEBABE
        );


        #20;

        $display("Simulation completed.");

        $finish;

    end


endmodule
