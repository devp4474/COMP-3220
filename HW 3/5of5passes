#
#  Parser Class
#
load "TinyToken.rb"
load "TinyLexer.rb"
class Parser < Lexer
	def initialize(filename)
		super(filename)
		consume()
		# variable to count parse errors
		@errors = 0
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
			@errors += 1
		end
		consume()
	end

	def program()
		while( @lookahead.type != Token::EOF)
			puts "Entering STMT Rule"
			statement()
		end
		# number of parse errors statement at end of program:
		puts "There were #{@errors} parse errors found."
	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			#puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end

		puts "Exiting STMT Rule"
	end

	def assign()
		# "entering assgn rule" puts statement is included in statement method
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
		end
		match(Token::ID)

		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		exp()
		puts "Exiting ASSGN Rule"
	end

	def exp()
		puts "Entering EXP Rule"
		term()
		etail()
		puts "Exiting EXP Rule"
	end

	def term()
		puts "Entering TERM Rule"
		# entering and exit statement for factor included in factor method
		factor()
		puts "Exiting TERM Rule"
		#etail()
	end

	def factor()
		puts "Entering FACTOR Rule"
		if (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN Token: #{@lookahead.text}"
			match(Token::LPAREN)
			exp()
			if
			(@lookahead.type == Token::RPAREN)
				puts "Found RPAREN Token: #{@lookahead.text}"
			end
			match(Token::RPAREN)
		elsif
		(@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
			match(Token::ID)
		elsif
		(@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"
			match(Token::INT)
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@errors += 1

		end
		puts "Exiting FACTOR Rule"
		ttail()
	end

	def etail()
		puts "Entering ETAIL Rule"
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP Token: #{@lookahead.text}"
			consume()
			term()
			etail()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP Token: #{@lookahead.text}"
			consume()
			term()
			etail()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end
		puts "Exiting ETAIL Rule"
	end

	def ttail()
		puts "Entering TTAIL Rule"
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP Token: #{@lookahead.text}"
			consume()
			factor()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP Token: #{@lookahead.text}"
			consume()
			factor()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
		puts "Exiting TTAIL Rule"
	end
end
