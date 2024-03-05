`timescale 1ns / 1ps

module axi_read_channel_tb;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in ns

    // Signals
    logic clk;
    logic aresetn;
    logic [31:0] araddr;
    logic [2:0] arprot;
    logic [3:0] arlen;
    logic [1:0] arsize;
    logic [2:0] arburst;
    logic arvalid;
    logic arready;
    logic [31:0] rdata;
    logic [1:0] rresp;
    logic rvalid;
    logic rready;

    // Instantiate DUT
    axi_read_channel dut (
        .aclk(clk),
        .aresetn(aresetn),
        .araddr(araddr),
        .arprot(arprot),
        .arlen(arlen),
        .arsize(arsize),
        .arburst(arburst),
        .arvalid(arvalid),
        .arready(arready),
        .rdata(rdata),
        .rresp(rresp),
        .rvalid(rvalid),
        .rready(rready)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Reset generation
    initial begin
        aresetn = 0;
        #50;
        aresetn = 1;
        #50;
    end

    // Testbench stimulus
    initial begin
        // Initialize inputs
        araddr = 32'h00000000;
        arprot = 3'b000;
        arlen = 4'b0000;
        arsize = 2'b00;
        arburst = 3'b000;
        arvalid = 0;

        // Wait for reset to complete
        #100;

        // Send read address request
        arvalid = 1;
        #10;
        arvalid = 0;

        // Wait for read response
        @(posedge clk);
        while (!rvalid) begin
            @(posedge clk);
        end

        // Display read data and response
        $display("Read Data: %h", rdata);
        $display("Read Response: %h", rresp);

        // End simulation
        $finish;
    end

endmodule
