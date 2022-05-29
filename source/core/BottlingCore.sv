module BottlingCore (
    input logic clk,
    input logic reset_n,
    input logic display_flicker,
    input logic pill_pulse,
    input logic flip_working,
    input logic shift_selection,
    input logic[7:0] bottle_setting,
    input logic[7:0] pill_setting,
    output logic[3:0] bcd[3:1],
    output logic oe,
    output logic[4:0] selection,
    output logic working,
    output logic finished,
    output logic beep
);

    StatusController status_controller(
        .clk(clk),
        .reset_n(reset_n),
        .flip_working(flip_working),
        .shift_selection(shift_selection),
        .working(working),
        .selection(selection)
    );

    logic working_reset;
    assign working_reset = working & flip_working;

    logic[11:0] total_current;
    logic[7:0] bottle_current;
    logic[7:0] pill_current;

    WorkingCounters working_counters(
        .clk(clk),
        .reset_n(reset_n & !working_reset),
        .en(working),
        .pill_pulse(pill_pulse),
        .bottle_setting(bottle_setting),
        .pill_setting(pill_setting),
        .total(total_current),
        .bottle(bottle_current),
        .pill(pill_current),
        .finished(finished)
    );

    DisplayController controller(
        .working(working),
        .selection(selection),
        .display_flicker(display_flicker),

        .total_current(total_current),
        .bottle_current(bottle_current),
        .pill_current(pill_current),

        .bottle_setting(bottle_setting),
        .pill_setting(pill_setting),

        .bcd({bcd[3], bcd[2], bcd[1]}),
        .oe(oe)
    );

    assign beep = finished & display_flicker;

endmodule
