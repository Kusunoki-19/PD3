classdef RingQ < handle
    %RINGQ ring baffer
    %   enQ method
    %   deQ method
    %   readQ method
    %   printQ method
    %   printWaitingQ method
    
    properties 
        length
        q
        head
        tail
    end
    
    methods
        function obj = RingQ(length ,head, tail)
            %RINGQ constractor 
            %   initialize ringQ length, frotn and tail
            
            %data suffix must be between (1 ~ datalen)
            if (head > 0) && (head < length)
                head = 1;
            end
            if (tail > 0) && (tail < length)
                tail = 1;
            end
            %head must be not tail
            if head == tail
                tail = tail + 1;
            end
            
            obj.q = zeros(length,1);
            obj.length = length;
            obj.head = head;
            obj.tail = tail;
        end
        
        function outSuf = suffix(obj, inSuf)
            %SUFFIX calculate suffix of ring queue
            
            % if data len == 3, then convert like
            % 0 (rem)-> 0 (if 0)-> 3
            % 1 (rem)-> 1
            % 2 (rem)-> 2 
            % 3 (rem)-> 0 (if 0)-> 3 , 
            % 4 (rem)-> 1
            outSuf = rem(inSuf, obj.length);
            if outSuf == 0
                outSuf = obj.length;
            end
        end
        
        function enQ(obj,indata)
            %ENQ enqueue method
            %   indata : double list : enqueue data
            for i = 1:length(indata)
                if obj.head == obj.tail + 1
                    warning('warning : head == tail');
                    break;
                end
                obj.q(obj.tail) = indata(i);
                obj.tail = obj.suffix(obj.tail + 1);
            end
        end
        
        function outdata = deQ(obj,deQLen)
            %DEQ dequeue method
            %   deQLen : int : dequeue length
            oudata = zeros(deQLen);
            for i = 1:deQLen
                %head‚©‚çæ‚èo‚µ‚ÄXV
                if obj.head + 1 == obj.tail
                    warning('warning : head == tail');
                    break;
                end
                outdata(i) = obj.q(obj.head);
                obj.head = obj.suffix(obj.head + 1);
            end
        end
        
        function outdata = readQ(obj,readA, readB)
            %READQ read out method
            %   readA : int : read start
            %   readB : int : read end
            if readB < readA
                readB = readB + obj.length;
            end
            deQLen = readB - readA + 1;
            
            outdata = zeros(deQLen);         
            for i = 0:deQLen - 1
                outdata(1 + i) = obj.q(obj.suffix(readA + i));
            end
        end
        
        function printQ(obj, readA, readB)
            %PRINTQ print queue between readA to readB
            outdata = obj.readQ(readA, readB);
            deQLen = length(outdata);
            
            for i = 0:deQLen - 1
                fprintf('Q[%d] : %d\n',obj.suffix(readA + i), outdata(1 + i));
            end
        end
        
        function printWaitingQ(obj)
            %PRINTWAITINGQ print queue between head to (tail -1)
            obj.printQ(obj.head, obj.suffix(obj.tail - 1));
        end
        
    end
end

