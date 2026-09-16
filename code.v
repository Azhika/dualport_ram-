module simple_dual_port_ram(
    input wire clk,
    input wire we_a,
    input wire  [9:0] addr_a,
    input wire [31:0] din_a,
    input wire [9:0] addr_b,
    output reg [31:0] dout_b
    );
    reg[31:0] ram[0:1023];
    (* ram_style = "block" *)
    always@(posedge clk) begin
    if(we_a)
    ram[addr_a]<=din_a;
    end
    always@(posedge clk) begin
    dout_b<=ram[addr_b];
    end
    
endmodule
