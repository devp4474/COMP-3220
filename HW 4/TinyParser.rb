#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			      @errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
      term = term()
      if (@lookahead.type == Token::ADDOP or @lookahead.type == Token::SUBOP)
        exp = etail()
        exp.addAsFirstChild(term)
        exp.shiftDown()
      else
        exp = term
      end
      return exp
    end

    def term()
      factor = factor()
      if (@lookahead.type == Token::MULTOP or @lookahead.type == Token::DIVOP)
        term = ttail()
        term.addAsFirstChild(factor)
        term.shiftDown()
      else
        term = factor
      end
      return term
    end

    def factor()
        factor = AST.new(Token.new("factor","factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            factor = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				        match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
          factor = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
          factor = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return factor
    end

    def ttail()
      ttail = AST.new(Token.new("ttail","ttail"))
        if (@lookahead.type == Token::MULTOP)
            ttail = AST.new(@lookahead)
            match(Token::MULTOP)
            ttail.setNextSibling(factor())
            rttail = ttail()
            if (rttail != nil)
              rttail.addAsFirstChild(ttail)
              ttail = rttail
            end
        elsif (@lookahead.type == Token::DIVOP)
            div = AST.new(@lookahead)
            match(Token::DIVOP)
            div.setNextSibling(factor())
            rttail = div()
            if (rttail != nil)
              rttail.addAsFirstChild(div)
              div = rttail
            end
		    else
			    return nil
        end
          return ttail
    end

    def etail()
        etail = AST.new(Token.new("etail","etail"))
        if (@lookahead.type == Token::ADDOP)
            etail = AST.new(@lookahead)
            match(Token::ADDOP)
            etail.setNextSibling(term())
            rttail = etail()
            if (rttail != nil)
              rttail.addAsFirstChild(etail)
              etail = rttail
            end
        elsif (@lookahead.type == Token::SUBOP)
            sub = AST.new(@lookahead)
            match(Token::SUBOP)
            sub.setNextSibling(term())
            rttail = etail()
            if (rttail != nil)
              rttail.addAsFirstChild(sub)
              sub = rttail
            end
		else
			return nil
        end
        return etail
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end
