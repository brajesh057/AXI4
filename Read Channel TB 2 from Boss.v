`timescale 1ns / 1ps

module axi_read_channel_tb;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in ns

    // Signals
    logic aclk;
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

    // Instantiate the DUT
    axi_read_channel dut (
        .aclk(aclk),
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
    always #((CLK_PERIOD / 2)) aclk = ~aclk;

    // Reset generation
    initial begin
        aresetn = 0;
        #10;
        aresetn = 1;
        #10;
    end

    // Test sequence
    initial begin
        // Wait for reset release
        #100;

        // Read address transaction 1
        araddr = 32'h00000004; // Example address
        arprot = 3'b000; // Example protection
        arlen = 4'b0010; // Example burst length
        arsize = 2'b10; // Example burst size
        arburst = 3'b01; // Example burst type
        arvalid = 1;
        #20;
        arvalid = 0;
        #50;

        // Read address transaction 2
        araddr = 32'h00000008; // Example address
        arprot = 3'b000; // Example protection
        arlen = 4'b0010; // Example burst length
        arsize = 2'b10; // Example burst size
        arburst = 3'b01; // Example burst type
        arvalid = 1;
        #20;
        arvalid = 0;
        #50;

        // Add more test sequences as needed

        // End simulation
        $finish;
    end

    // Monitor for read response
    always @(posedge aclk) begin
        if (rvalid && rready) begin
            $display("Read Data: %h, Read Response: %h", rdata, rresp);
        end
    end

endmodule
