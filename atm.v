








module atm(input	clk,
	input	BTN3,BTN2,BTN1,rst,
	input	[3:0]SW,
	output	reg[7:0] LED,		// led[7] is the leftmost ssd
	output	reg[6:0] digit1,digit2,digit3,digit4 //digit4 is the leftmost ssd
	);
	
	reg[3:0]	password;
	reg[15:0] 	balance;
	reg[3:0] 	current_state;
	reg[3:0] 	next_state;
	reg[7:0]	lock_timeup;
	reg[6:0]	warning_timeup;
	reg[3:0]	balance_4,balance_3,balance_2,balance_1;
   reg[6:0]    SSD_out_4,SSD_out_3,SSD_out_2,SSD_out_1;

	// STATES ARE DEFINED BELOW.  
	parameter [3:0]	IDLE		=4'b0000;
	parameter [3:0]	PASS_ENT_3	=4'b0001;
	parameter [3:0] PASS_ENT_2	=4'b0010;
	parameter [3:0] PASS_ENT_1	=4'b0011;
	parameter [3:0] LOCK		=4'b0100;
	parameter [3:0] ATM_MENU	=4'b0101;
	parameter [3:0] PASS_CHG_3	=4'b0110;
	parameter [3:0] PASS_CHG_2	=4'b0111;
	parameter [3:0] PASS_CHG_1	=4'b1000;
	parameter [3:0] PASS_NEW	=4'b1001;
	parameter [3:0] MONEY		=4'b1010;
	parameter [3:0] WARNING		=4'b1011;

	// SSD DISPLAYS ARE DEFINED BELOW.
	//		_     6	
	//     |_|  1-0-5	THESE NUMS ARE THE INDEXS OF BITS FROM RIGHT TO LEFT.
	//     |_|  2-3-4	6TH-5TH-4TH-3RD-2ND-1RST-0TH BITS
	// 
	// I CODED SSD ACCORDING TO THE VISUAL ABOVE, DEFINITIONS ARE BELOW.

	parameter [6:0] ONE = 	  7'b1001111; /*it is same as letter I*/
	parameter [6:0] TWO = 	  7'b0010010; 
	parameter [6:0] THREE= 	  7'b0000110;
	parameter [6:0] letter_P= 7'b0011000;
	parameter [6:0] letter_E= 7'b0110000;
	parameter [6:0] letter_C= 7'b0110001;
	parameter [6:0] letter_A= 7'b0001000;
	parameter [6:0] letter_n= 7'b1101010;
	parameter [6:0] letter_r= 7'b1111010;
	parameter [6:0] letter_d= 7'b1000010;
	parameter [6:0] letter_F= 7'b0111000;
	parameter [6:0] letter_L= 7'b1110001;
	parameter [6:0] letter_O= 7'b0000001;
	parameter [6:0] letter_S= 7'b0100100;
	parameter [6:0] dash = 7'b1111110;


// bu kýsým sonradan eklendý ve asagýdaký devrenýn clocku dývýded clock ýle degýstýrýldý.
//	 reg divided_clk;
//	clk_divider div(.clk_in(clk),.rst(rst),.divided_clk(divided_clk));
//	
//	 reg BTN3,BTN2,BTN1,rst;
//	debouncer button_cleaner3(.clk(divided_clk),.rst(rst),.noisy_in(BTN3),.out(BTN3));
//		debouncer button_cleaner2(.clk(divided_clk),.rst(rst),.noisy_in(BTN2),.out(BTN2));
//			debouncer button_cleaner1(.clk(divided_clk),.rst(rst),.noisy_in(BTN1),.out(BTN1));
//				//debouncer button_cleaner_rst(.clk(divided_clk),.rst(rst),.noisy_in(rst),.out(rst));//sanýrým buna gerek yok degýstýrmedým o yuzden buna býr bakalým ****************************************************************************
	
	
//	ssd ssd_out(.clk,.reset,		.a0(digit1[6]),.a1(digit2[6]),.a2(digit3[6]),.a3(digit4[6]),
//											.b0(digit1[5]),.b1(digit2[5]),.b2(digit3[5]),.b3(digit4[5]),
//											.c0(digit1[4)),.c1(digit2[4]),.c2(digit3[4]),.c3(digit4[4]),
//											.d0(digit1[3]),.d1(digit2[3]),.d2(digit3[3]),.d3(digit4[3]),
//											.e0(digit1[2]),.e1(digit2[2]),.e2(digit3[2]),.e3(digit4[2]),
//											.f0(digit1[1]),.f1(digit2[1]),.f2(digit3[1]),.f3(digit4[1]),
//											.g0(digit1[0]),.g1(digit2[0]),.g2(digit3[0]),.g3(digit4[0]),
//											.a(),.b(),.c(),.d(),.e(),.f(),.g(),
//											.an0(),.an1(),.an2(),.an3()
//          );
	
	always @(*)
    begin
        case(balance_4)
        4'b0000: SSD_out_4 = 7'b0000001; // "0"     
        4'b0001: SSD_out_4 = 7'b1001111; // "1" 
        4'b0010: SSD_out_4 = 7'b0010010; // "2" 
        4'b0011: SSD_out_4 = 7'b0000110; // "3" 
        4'b0100: SSD_out_4 = 7'b1001100; // "4" 
        4'b0101: SSD_out_4 = 7'b0100100; // "5" 
        4'b0110: SSD_out_4 = 7'b0100000; // "6" 
        4'b0111: SSD_out_4 = 7'b0001111; // "7" 
        4'b1000: SSD_out_4 = 7'b0000000; // "8"     
        4'b1001: SSD_out_4 = 7'b0000100; // "9"
        4'b1010: SSD_out_4 = 7'b0001000; // A
        4'b1011: SSD_out_4 = 7'b1100000; // b
        4'b1100: SSD_out_4 = 7'b0110001; // C
        4'b1101: SSD_out_4 = 7'b1000010; // d
        4'b1110: SSD_out_4 = 7'b0110000; // E
        4'b1111: SSD_out_4 = 7'b0111000; // F 
        default: SSD_out_4 = 7'b0000001; // "0" 
        endcase
    end
    

    always @(*)
    begin
        case(balance_3)
        4'b0000: SSD_out_3 = 7'b0000001; // "0"     
        4'b0001: SSD_out_3 = 7'b1001111; // "1" 
        4'b0010: SSD_out_3 = 7'b0010010; // "2" 
        4'b0011: SSD_out_3 = 7'b0000110; // "3" 
        4'b0100: SSD_out_3 = 7'b1001100; // "4" 
        4'b0101: SSD_out_3 = 7'b0100100; // "5" 
        4'b0110: SSD_out_3 = 7'b0100000; // "6" 
        4'b0111: SSD_out_3 = 7'b0001111; // "7" 
        4'b1000: SSD_out_3 = 7'b0000000; // "8"     
        4'b1001: SSD_out_3 = 7'b0000100; // "9" 
        4'b1010: SSD_out_3 = 7'b0001000; // A
        4'b1011: SSD_out_3 = 7'b1100000; // b
        4'b1100: SSD_out_3 = 7'b0110001; // C
        4'b1101: SSD_out_3 = 7'b1000010; // d
        4'b1110: SSD_out_3 = 7'b0110000; // E
        4'b1111: SSD_out_3 = 7'b0111000; // F
        default: SSD_out_3 = 7'b0000001; // "0"

        endcase
    end
    
    always @(*)
    begin
        case(balance_2)
        4'b0000: SSD_out_2 = 7'b0000001; // "0"     
        4'b0001: SSD_out_2 = 7'b1001111; // "1" 
        4'b0010: SSD_out_2 = 7'b0010010; // "2" 
        4'b0011: SSD_out_2 = 7'b0000110; // "3" 
        4'b0100: SSD_out_2 = 7'b1001100; // "4" 
        4'b0101: SSD_out_2 = 7'b0100100; // "5" 
        4'b0110: SSD_out_2 = 7'b0100000; // "6" 
        4'b0111: SSD_out_2 = 7'b0001111; // "7" 
        4'b1000: SSD_out_2 = 7'b0000000; // "8"     
        4'b1001: SSD_out_2 = 7'b0000100; // "9" 
        4'b1010: SSD_out_2 = 7'b0001000; // A
        4'b1011: SSD_out_2 = 7'b1100000; // b
        4'b1100: SSD_out_2 = 7'b0110001; // C
        4'b1101: SSD_out_2 = 7'b1000010; // d
        4'b1110: SSD_out_2 = 7'b0110000; // E
        4'b1111: SSD_out_2 = 7'b0111000; // F
        default: SSD_out_2 = 7'b0000001; // "0"
        endcase
    end

    always @(*)
    begin
        case(balance_1)
        4'b0000: SSD_out_1 = 7'b0000001; // "0"     
        4'b0001: SSD_out_1 = 7'b1001111; // "1" 
        4'b0010: SSD_out_1 = 7'b0010010; // "2" 
        4'b0011: SSD_out_1 = 7'b0000110; // "3" 
        4'b0100: SSD_out_1 = 7'b1001100; // "4" 
        4'b0101: SSD_out_1 = 7'b0100100; // "5" 
        4'b0110: SSD_out_1 = 7'b0100000; // "6" 
        4'b0111: SSD_out_1 = 7'b0001111; // "7" 
        4'b1000: SSD_out_1 = 7'b0000000; // "8"     
        4'b1001: SSD_out_1 = 7'b0000100; // "9" 
        4'b1010: SSD_out_1 = 7'b0001000; // A
        4'b1011: SSD_out_1 = 7'b1100000; // b
        4'b1100: SSD_out_1 = 7'b0110001; // C
        4'b1101: SSD_out_1 = 7'b1000010; // d
        4'b1110: SSD_out_1 = 7'b0110000; // E
        4'b1111: SSD_out_1 = 7'b0111000; // F
        default: SSD_out_1 = 7'b0000001; // "0"
        endcase
    end

	// I used rst as rst button.
	// STATE CHANGES AT POSITIVE EDGE IN THIS ALWAYS@
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			current_state <= 0;
			//balance <= 0;
			//password <= 0;
		end
		else
			current_state <= next_state;
	end

	// NEXT STATE IS UPDATED ACCORDING TO INPUTS IN THIS ALWAYS@
	//THEY ARE UPDATED WITH COMBINATIONAL DESIGN
	always @ (*)
	begin
			case(current_state)
			IDLE:
			begin
				if(BTN3==1) 	next_state = PASS_ENT_3;
				else		next_state = IDLE;
			end
			
			/**************************************************************/
			//PASSWORD ENTRY CONTROL STAGE_START
			PASS_ENT_3:
			begin
				if(BTN1==1'b1)next_state=IDLE;
				else if(BTN3==1'b1 & password==SW)next_state = ATM_MENU;
				else if(BTN3==1'b1 & password!=SW)next_state= PASS_ENT_2;
				else next_state=PASS_ENT_3;
			end		
             		

			PASS_ENT_2:	
			begin
                                if(BTN1==1'b1)next_state=IDLE;
                                else if(BTN3==1'b1 & password==SW)next_state = ATM_MENU;
                                else if(BTN3==1'b1 & password!=SW)next_state= PASS_ENT_1;
                                else next_state=PASS_ENT_2;
            end  

			PASS_ENT_1:
			begin
                                if(BTN1==1)next_state=IDLE;
                                else if(BTN3==1'b1 & password==SW)next_state = ATM_MENU;
                                else if(BTN3==1'b1 & password!=SW)next_state= LOCK;
                                else next_state= PASS_ENT_1;
            end  

			LOCK:
			begin
				if(lock_timeup==100) next_state= IDLE;
				else next_state = LOCK;
			end
			// PASSWORD ENTRY CONTROL STAGE_END
			/****************************************************************/
			
			ATM_MENU:
			begin
				if(BTN1==1'b1) next_state=IDLE;
				else if(BTN2==1'b1) next_state= PASS_CHG_3;
				else if(BTN3==1'b1) next_state= MONEY;
				else next_state = ATM_MENU;
			end
			
			/****************************************************************/
			//PASSWORD CHANGE CONTROL STAGE_START
			PASS_CHG_3:
            begin
                if(BTN1==1'b1)next_state=ATM_MENU;
                else if(BTN3==1'b1 & password==SW)next_state = PASS_NEW;
                else if(BTN3==1'b1 & password!=SW)next_state= PASS_CHG_2;
                else next_state=PASS_CHG_3;
            end

            PASS_CHG_2:
            begin
                if(BTN1==1'b1)next_state=ATM_MENU;
                else if(BTN3==1'b1 & password==SW) next_state = PASS_NEW;
                else if(BTN3==1'b1 & password!=SW) next_state= PASS_CHG_1;
                else next_state=PASS_CHG_2;
            end  

            PASS_CHG_1:
                        begin
                                if(BTN1==1'b1)next_state=ATM_MENU;
                                else if(BTN3==1'b1 & password==SW)next_state = PASS_NEW;
                                else if(BTN3==1'b1 & password!=SW)next_state= LOCK;
                                else  next_state= PASS_CHG_1;
                        end  
			//PASSWORD CHANGE CONTROL STAGE_END
			/****************************************************************/

			PASS_NEW:
			begin
				if(BTN1) next_state=ATM_MENU;
				else if(BTN3)next_state=ATM_MENU;
				else next_state=PASS_NEW;
			end
			
			MONEY:
			begin
				if(BTN1)next_state=ATM_MENU;
				else if(BTN2 & balance< SW) next_state = WARNING;
				else next_state=MONEY;
			end

			WARNING:
			begin
				if(warning_timeup==50)next_state=MONEY;
				else next_state = WARNING;
			end

			endcase

	end

	//REGISTERS UPDATED ACCORDING TO STATES AND INPUT IN THIS ALWAYS@
	// REGISTERS ARE UPDATED IN POSITIVE CLOCK EDGE I.E SEQUANTIALLY
	always @ (posedge clk or posedge rst)
	begin
	
		if(rst)
		begin
			balance <= 0;
			password <= 0;
		end
		else
		case(current_state)
		
		//OUR REGISTERS ARE: password,balance,warning_timeup,lock_timeup
		// we will consider cases which are related with these registers only
		
			PASS_ENT_1:
			begin
				if(BTN3==1 & SW!= password) lock_timeup<=0;
			end

			LOCK:
			begin
			    lock_timeup <= lock_timeup+1;
			end
	
			
			PASS_CHG_1:
			begin
				if(BTN3==1 & SW!= password ) lock_timeup <=0;
			end			

			PASS_NEW:
			begin
				if(BTN3) password <=SW;
			end

			MONEY:
			begin

				balance_4<= balance[15:12];
				balance_3<= balance[11:8];
				balance_2<= balance[7:4];
				balance_1<= balance[3:0];
				if(BTN2 & balance< SW)warning_timeup <= 0;
				else if (BTN2 & balance>= SW)balance <= balance-SW;
				else if (BTN3) balance <= balance + SW;



			end

			WARNING:
			begin
			     warning_timeup <= warning_timeup +1;
			end	
			
			endcase
	end
	
	//OUTPUTS UPDATED IN THIS ALWAYS@ ACCORDING TO STATES(MOORE MACHINE)
	//OUTPUTS ARE UPDATED COMBINATIONALLY
	always @ (*)
        begin
                case(current_state)

                        IDLE:
                        begin
                               	digit4=letter_C;
								digit3=letter_A;
								digit2=letter_r;
								digit1=letter_d;
								LED = 8'b00000001;
                        end
                        PASS_ENT_3:
                        begin
                                digit4=letter_P;
                                digit3=letter_E;
                                digit2=dash;
                                digit1=THREE;
                                LED = 8'b10000000;
                        end

                        PASS_ENT_2:
                        begin
                                digit4=letter_P;
                                digit3=letter_E;
                                digit2=dash;
                                digit1=TWO;
                                LED = 8'b11000000;
                        end
                        PASS_ENT_1:
                        begin
                                digit4=letter_P;
                                digit3=letter_E;
                                digit2=dash;
                                digit1=ONE;
                                LED = 8'b11100000;
                        end
                        LOCK:
                        begin
                                digit4=letter_F;
                                digit3=letter_A;
                                digit2=ONE;
                                digit1=letter_L;
                                LED = 8'b11111111;
                        end
                        ATM_MENU:
                        begin
                                digit4=letter_O;
                                digit3=letter_P;
                                digit2=letter_E;
                                digit1=letter_n;
                                LED = 8'b00010000;
                        end
                        PASS_CHG_3:
                        begin
                                digit4=letter_P;
                                digit3=letter_C;
                                digit2=dash;
                                digit1=THREE;
                                LED = 8'b00000100;
                        end
                        PASS_CHG_2:
                        begin
                                digit4=letter_P;
                                digit3=letter_C;
                                digit2=dash;
                                digit1=TWO;
                                LED = 8'b00000110;
                        end
                        PASS_CHG_1:
                        begin
                                digit4=letter_P;
                                digit3=letter_C;
                                digit2=dash;
                                digit1=ONE;
                                LED = 8'b00000111;
                        end
                        PASS_NEW:
                        begin
                                digit4=letter_P;
                                digit3=letter_A;
                                digit2=letter_S;
                                digit1=letter_S;
                                LED = 8'b00000010;
                        end
                        MONEY:
                        begin
				
                                digit4=SSD_out_4;
                                digit3=SSD_out_3;
                                digit2=SSD_out_2;
                                digit1=SSD_out_1;
                                LED = 8'b00001000;
                        end
                        WARNING:
                        begin
                                digit4=dash;
                                digit3=letter_n;
                                digit2=letter_A;
                                digit1=dash;
                                LED = 8'b11111111;
                        end

                        endcase
	end

endmodule
