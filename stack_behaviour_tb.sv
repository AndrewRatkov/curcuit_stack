`include "stack_behaviour.sv"

// tests_for modules
// 1 means that test will run
// 0 means thhat test will not run
bit test_main = 0;

bit need_to_test_Stack = 1 & (!test_main);
bit need_to_debug_Stack = 1 & (!test_main);


module test_Stack();
    reg debug = need_to_debug_Stack;
    int errors = 0;

    reg OP0, OP1, RESET, C;
    reg[2:0] G;
    reg [3:0] D;

    wire ANS0, ANS1,  ANS2, ANS3; // ВЫХОДЫ
    wire Z;

    Stack test_stack(.OP0(OP0), .OP1(OP1), .RESET(RESET), .C(C), .G(G), .D(D), .ANS0(ANS0), .ANS1(ANS1), .ANS2(ANS2), .ANS3(ANS3));

    initial begin
        if (need_to_test_Stack) begin
//            $monitor("time: %0d: OP: %b %b;  RESET: %b C: %b NEW: %b SAVED: %b", $time, OP0, OP1, RESET, C, NEW, SAVED);
            OP0 = 1; OP1 = 1; C = 0; RESET = 1; D = 4; G = 0; #1;
            RESET = 0; #1;
            C = 1; #1;
//            $display("=== %b %b %b %b", ANS0, ANS1, ANS2, ANS3);
            C = 0; #1;
            OP0 = 1; OP1 = 0; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            D = 15; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            D = 2; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 0; OP1 = 1; #1;
            C = 1; #1;
            if (debug)
                $display("POPPED %b %b %b %b", ANS3, ANS2, ANS1, ANS0);
            C = 0; #1;
            OP0 = 1; OP1 = 0; D = 7; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 1; OP1 = 0; D = 1; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 0; D = 10; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 1; OP1 = 0; D = 11; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            D[0] = Z; D[1] = Z; D[2] = Z; D[3] = Z;
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            #200;
            if (errors)
                $display("%b errors happened in Stack", errors);
            else begin
                $display("No errors in Stack!");
            end
        end
    end
endmodule

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

            $display("2)Давайте теперь запушаем что-то: (4; 15; 2)");
            COMMAND = 1; IO_DATA2 = 4; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 15; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 2; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            COMMAND = 3; IO_DATA2 = 4'bZZZ; #1;
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

            $display("3)Сделаем два раза pop");
            COMMAND = 2; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
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

            $display("4)Давайте снова запушаем что-то: (10, 3, 9, 8)");
            COMMAND = 1; IO_DATA2 = 10; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 3; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 9; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 8; #1;
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

            $display("5)И ещё раз запушаем что-то, чтобы случился переход по циклу и перезапись: (1, 0, 5)");
            COMMAND = 1; IO_DATA2 = 1; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 0; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 5; #1;
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

            $display("6)Снова делаем RESET");
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

            $display("7)Попробуем сделать pop");
            COMMAND = 2; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
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

            $display("8)Давайте снова запушаем что-то: (4)");
            COMMAND = 1; IO_DATA2 = 4; #1;
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