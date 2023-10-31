#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead
	def initialize(filename)
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		if (File.exists?(filename))
			@f = File.open(filename,'r:utf-8')
		else puts 'File not found.'
		end
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end

	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end

		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken()
		#EOF
		if @c == "eof"
			return Token.new(Token::EOF,"eof")
			#WHITESPACE
		elsif (whitespace?(@c))
			str =""

			while whitespace?(@c)
				str += @c
				nextCh()
			end

			tok = Token.new(Token::WS,str)
			#print, epsilon, ID
		elsif (letter?(@c))
			str = ""

			while letter?(@c)
				str += @c
				nextCh()
			end

			if (str == 'print')
				tok = Token.new(Token::PRINT,str)
			elsif (str == 'epsilon')
				tok = Token.new(Token::EPSILON,str)
				#if and while for bonus
			elsif (str == 'if')
				tok = Token.new(Token::IFSTMT, str)
			elsif (str == 'while')
				tok = Token.new(Token::LOOPSTMT, str)
				#else for any other letters
			else
				tok = Token.new(Token::ID,str)
			end
			#INTs
		elsif (numeric?(@c))
			int = ""

			while (numeric?(@c))
				int += @c
				nextCh()
			end
			tok = Token.new(Token::INT,int)
			#other characters and opps
		elsif (@c == '(')
			nextCh()
			tok = Token.new(Token::LPAREN,"(")
		elsif (@c == ')')
			nextCh()
			tok = Token.new(Token::RPAREN,")")
		elsif (@c == '+')
			nextCh()
			tok = Token.new(Token::ADDOP,"+")
		elsif (@c == "-")
			nextCh()
			tok = Token.new(Token::SUBOP, "-")
		elsif (@c == "*")
			nextCh()
			tok = Token.new(Token::MULTOP, "*")
		elsif (@c == "/")
			nextCh()
			tok = Token.new(Token::DIVOP, "/")
		elsif (@c == "=")
			nextCh()
			tok = Token.new(Token::EQUALS, "=")
			#for bonus
		elsif (@c == ">")
			nextCh()
			tok = Token.new(Token::GREATER, ">")
		elsif (@c == "<")
			nextCh()
			tok = Token.new(Token::LESS, "<")
		elsif (@c == "&")
			nextCh()
			tok = Token.new(Token::AND, "&")
			#unknown
		else
			tok = Token.new(Token::UNKNWN, @c)
			nextCh()
		end
		puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}"
		return tok
		# elsif ...
		# more code needed here! complete the code here
		# so that your scanner can correctly recognize,
		# print (to a text file), and display all tokens
		# in our grammar that we found in the source code file

		# FYI: You don't HAVE to just stick to if statements
		# any type of selection statement "could" work. We just need
		# to be able to programatically identify tokens that we
		# encounter in our source code file.

		# don't want to give back nil token!
		# remember to include some case to handle
		# unknown or unrecognized tokens.
		# below is an example of how you "could"
		# create an "unknown" token directly from
		# this scanner. You could also choose to define
		# this "type" of token in your token class
		#
		# tok = Token.new(Token::UNKNWN,@c) <- commented this out and just did it in the else basically
	end

end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
	end