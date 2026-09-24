// SPDX-License-Identifier: Apache-2.0

module chip_core (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] input_in,
    output logic [7:0] output_out
);

    (* async_reg = "true" *) logic rst_meta_n;
    (* async_reg = "true" *) logic rst_core_n;

    (* async_reg = "true" *) logic [7:0] gpio_meta;
    (* async_reg = "true" *) logic [7:0] gpio_sync;

    // Asynchronous assertion, two-stage synchronous release.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_meta_n <= 1'b0;
            rst_core_n <= 1'b0;
        end else begin
            rst_meta_n <= 1'b1;
            rst_core_n <= rst_meta_n;
        end
    end

    // Use the same scalar reset in the event list and condition.
    always_ff @(posedge clk or negedge rst_core_n) begin
        if (!rst_core_n) begin
            gpio_meta <= '0;
            gpio_sync <= '0;
        end else begin
            gpio_meta <= input_in;
            gpio_sync <= gpio_meta;
        end
    end

    el2_soc u_soc (
        .clk             (clk),
        .rst_n           (rst_core_n),
        .gpio_in         (gpio_sync),
        .gpio_out        (output_out),
        .trace_valid     (),
        .trace_exception (),
        .trace_pc        ()
    );

endmodule
