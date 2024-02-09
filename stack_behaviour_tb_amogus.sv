`include "stack_behaviour.sv"

// tests_for modules
// 1 means that test will run
// 0 means thhat test will not run
bit test_main = 1;


module stack_behaviour_tb;
    reg debug = 0;
    int errors = 0;

    wire[3:0] IO_DATA;
    reg RESET;
    reg CLK;
    reg[1:0] COMMAND;
    reg[2:0] INDEX;

    // ввод данных утроен так: мы просто пишем, что хотим положить, в IO_DATA2
    // если мы собираемся сделать pop/get, в IO_DATA2 надо присвоить 4'bZZZZ
    reg[3:0] IO_DATA2;
    assign IO_DATA = IO_DATA2;

    stack_behaviour_normal stack(.IO_DATA(IO_DATA), .RESET(RESET), .CLK(CLK), .COMMAND(COMMAND), .INDEX(INDEX));

    initial begin
        if (test_main) begin
            // когда хотим делать pop/get, в IO_DATA2 надо присвоить 4'bZZZZ

            $display("DEBUG MAIN");
            // для начала давайте просто сделаем RESET
            $display("1)Делаем RESET");
            COMMAND = 1; CLK = 0; RESET = 1; IO_DATA2 = 4'bZZZZ; INDEX = 0; #1;
            RESET = 0; #1;
            $display("Проверим, что везде лежат нули:");
            // проверим, что везде лежат нули
            COMMAND = 3; #1;
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("2)Давайте теперь запушаем что-то: (1)");
            COMMAND = 1; IO_DATA2 = 1; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            
            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;


        end
    end

    
endmodule

// module test_stack_behaviour_normal();
//     wire[3:0] IO_DATA;
//     reg RESET;
//     reg CLK;
//     reg[1:0] COMMAND;
//     reg[2:0] INDEX;
//     reg[3:0] IO_DATA_INPUT = 4'bZZZZ;
//     int i = 0, j = 0;
//     int exceptions = 0;
//     stack_behaviour_normal new_(.IO_DATA(IO_DATA), 
//     .RESET(RESET), 
//     .CLK(CLK), .COMMAND(COMMAND),
//     .INDEX(INDEX));
//     assign IO_DATA = IO_DATA_INPUT;
//     initial begin
//         IO_DATA_INPUT = 4'bZZZZ; #1;
//         $display("%b", IO_DATA);
//         COMMAND = 1; CLK = 0; INDEX = 0;
//         #1 RESET = 1; #1; RESET = 0; #1;
//         $display("%b", IO_DATA);
//         CLK = 0; #1; COMMAND = 3; INDEX = 0;
//         #1
//         COMMAND = 1; IO_DATA_INPUT = 1; #1; CLK = 1;
//         #1
//         CLK = 0; #1; COMMAND = 3; INDEX = 0; IO_DATA_INPUT = 4'bZZZZ;
//         #1
//         CLK = 1;
//         #1;
//         $display("%b", IO_DATA);
//         for(int i = 0; i < 5; i++) begin
//             #1
//             COMMAND = 1; IO_DATA_INPUT = i; #1; CLK = 1;
//             #1
//             CLK = 0;
//             #1
//             COMMAND = 3; IO_DATA_INPUT = 4'bZZZZ; #1; CLK = 1;
//             #1 CLK = 0; #1;
//             for(j = 0; j < i; j++) begin
//                 #1
//                 INDEX = j;
//                 if (IO_DATA != i - j) exceptions++;
//         end
//         #1
//         CLK = 0;
//         end

//         for(int i = 0; i < 5; i++) begin
//             #1
//         CLK = 1; COMMAND = 2; IO_DATA_INPUT = 4'bZZZZ;
//         if (IO_DATA != 5 - i) exceptions++;
//         #1
//         CLK = 0;
//         end

//         for(int i = 0; i < 100; i++) begin
//             CLK = 1; COMMAND = 1; IO_DATA_INPUT = i % 16;
//             #1
//             CLK = 0;
//             #1
//             CLK = 1; COMMAND = 3; IO_DATA_INPUT = 4'bZZZZ; 
//             #1
//             INDEX = 0;
//             if (IO_DATA != i % 16) exceptions++;
//             #1
//             CLK = 0;
//             #1
//             CLK = 1; COMMAND = 2; IO_DATA_INPUT = 4'bZZZZ;
//             $display("%b", IO_DATA);
//             if (IO_DATA != i % 16) exceptions++;
//             #1
//             CLK = 0;
//         end
//         if (exceptions)
//             $display("Failed stack_behaviour_normal");
//         else $display("Correct stack_behaviour_normal!");
//     end
// endmodule