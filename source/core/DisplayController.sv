module DisplayController (
    input logic working,
    input logic[4:0] selection,
    input logic display_flicker,

    input logic[11:0] total_current,
    input logic[7:0] bottle_current,
    input logic[7:0] pill_current,

    input logic[7:0] bottle_setting,
    input logic[7:0] pill_setting,

    output logic[11:0] bcd,
    output logic oe
);

    always_comb
        case (selection)
            5'b10000: bcd = total_current;
            5'b01000: bcd = {4'hf, bottle_current};
            5'b00100: bcd = {4'hf, pill_current};
            5'b00010: bcd = {4'hf, bottle_setting};
            5'b00001: bcd = {4'hf, pill_setting};
            default: bcd = 12'hf;
        endcase

    assign oe = working | display_flicker;

endmodule
