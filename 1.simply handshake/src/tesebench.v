`timescale 1ns / 1ps

module tb_interface();
reg                              clk            ;
reg                              rstn           ;

// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
parameter  C_M_AXIS_TDATA_WIDTH	= 8;
parameter  C_S_AXIS_TDATA_WIDTH  =  8;
parameter NUMBER_OF_OUTPUT_WORDS = 20;       
parameter T = 20;
// Master Stream Ports. 
reg    M_AXIS_TVALID;
reg   [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA;
wire  M_AXIS_TREADY;

// Slaver Stream Ports. 
reg  S_AXIS_TREADY;
wire [C_M_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA;
wire S_AXIS_TVALID;

integer i ;
integer j ;
integer k ;
reg [7:0] tdata[NUMBER_OF_OUTPUT_WORDS-1:0] ;


initial begin
    clk = 0;
    forever begin
        #(T/2);
        clk = ~clk;
    end
end
//run
//integer fcols1;
initial begin
    #10;
    rstn = 0;
    repeat(10) @(posedge clk);
    rstn = 1;
    repeat(20) @(posedge clk);
    #10000;
    
    //$fclose(fcols1);
    $finish;

end



always @(negedge rstn)
begin
    M_AXIS_TVALID <= 0;
    M_AXIS_TDATA  <= 0;
    S_AXIS_TREADY <= 0;
    for(i = 0; i<NUMBER_OF_OUTPUT_WORDS;i = i + 1)
        tdata[i]  <= i;
    
end


initial begin
    @(posedge rstn)
    for(k = 0; k<8;k = k + 1)
    begin
        @(posedge clk) M_AXIS_TVALID <= 1; 
        M_AXIS_TDATA <= tdata[0];
        j = 0;
        while(j<=18)
        begin
            @(negedge clk);
            if(M_AXIS_TREADY)
            begin
                j = j + 1;
                @(posedge clk)
                M_AXIS_TDATA <= tdata[j];
                if(j>=19)
                M_AXIS_TVALID = 0; 
            end
            @(posedge clk);
        end
        @(posedge clk);
        @(posedge clk);
    end


end

initial begin
    forever begin
        @(negedge clk);
        if(S_AXIS_TVALID)
        begin
             @(posedge clk);
             S_AXIS_TREADY <= 1;
             @(posedge clk);
             S_AXIS_TREADY <= 0;
        end
    end
end


interface #
(
    .C_S00_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
    // Parameters of Axi Master Bus Interface M00_AXIS
    .C_M00_AXIS_TDATA_WIDTH (C_S_AXIS_TDATA_WIDTH)

)interface(

.aclk(clk),
.aresetn(rstn),

.s00_axis_tready(M_AXIS_TREADY),
.s00_axis_tdata(M_AXIS_TDATA),
.s00_axis_tvalid(M_AXIS_TVALID),

.m00_axis_tvalid(S_AXIS_TVALID),
.m00_axis_tdata(S_AXIS_TDATA),
.m00_axis_tready(S_AXIS_TREADY)
);


	
endmodule
