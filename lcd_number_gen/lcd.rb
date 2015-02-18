# lcd.rb

# Chapter 2: LCD Numbers of "Best Of Ruby Quiz" by James Edward Gray

# Problem setup follows.  My solution begins on line 33

=begin

This quiz is to write a program that displays LCD-style numbers at adjustable sizes.
The digits to be displayed will be passed as an argument to the program. Size should be controlled with the command-line option -s followed by a positive integer. The default value for -s is 2.
For example, if your program is called with this:
$ lcd.rb 012345
the correct display is this:
 --        --   --        --
|  |    |    |    | |  | |
|  |    |    |    | |  | |
           --   --   --   --
|  |    | |       |    |    |
|  |    | |       |    |    |
 --        --   --   --   --
And for this:
> lcd.rb -s 1 6789
your program should print this:
 -   -   -   -
|     | | | | |
 -       -   -
| |   | | |   |
 -       -   -
Note the single column of space between digits in both examples. For other values of -s, simply lengthen the - and | bars.

=end

if ARGV.include?("-s") # parse CLI arguments:
  lcd_height = ARGV[1].to_i
  number = ARGV[2]
else
  lcd_height = 2
  number = ARGV[0]
end

class LcdGenerator
	
  def initialize(number, height)
    @number = number
    @digits = number.chars
    @height = height.to_i
  end
	
  private
	
  def print_blank
    print " #{' '* @height} "
  end
	
  def print_horizontal_line
    print " #{"-"* @height} "
  end
	
  def print_left_vertical # print left-side upright
    print "|#{' ' * @height} "
  end
		
  def print_right_vertical # print right-side upright
    print " #{' ' * @height}|"
  end
	
  def print_left_and_right # print both uprights
    print "|#{' ' * @height}|"
  end

end

class LcdPrinter < LcdGenerator

  def print_all_rows # print all lcd number rows
    print_row1
    @height.times { print_row2 }
    print_row3
    @height.times { print_row4 }
    print_row5
  end
	
  private
	
  def print_row(&block) # eliminates repetition in print_rowx
    @digits.each do |n|
      block.call(n)
      print " "
    end
		puts
  end
	
  def print_row1 # print row 1 of 5 lcd number rows
    print_row do |n|		
      case n
      when "1", "4" then print_blank
      else print_horizontal_line # when "0", "2".."3" , "5".."9"
      end
    end
  end
			
  def print_row2 # print row 2 of 5 lcd number rows
    print_row do |n|		
      case n
      when "0", "4", "8".."9" then print_left_and_right
      when "5".."6" then print_left_vertical
      else print_right_vertical # when "1" , "2..3", "7"
      end
    end
  end

  def print_row3 # print row 3 of 5 lcd number rows
    print_row do |n|		
      case n
      when "0".."1", "7" then print_blank
      else print_horizontal_line # when "2".."6" , "8".."9"
      end
    end
  end

  def print_row4 # print row 4 of 5 lcd number rows
    print_row do |n|		
      case n
      when "0", "6", "8" then print_left_and_right
      when "2" then print_left_vertical							
      else print_right_vertical # when "1", "3".."5", "7", "9"
      end
    end
  end

  def print_row5 # print row 5 of 5 lcd number rows
    print_row do |n|		
      case n
      when "1", "4", "7" then print_blank
      else print_horizontal_line # when "0", "2".."3" , "5".."6", "8".."9"
      end
    end	
  end

end

p = LcdPrinter.new(number, lcd_height)
p.print_all_rows

# This solution works (CLI Output below) but I would like to refactor it to adhere to Sandi Metz's design principles.

=begin

[2015Feb17 19:41:40] lcd_number_gen $ ruby lcd.rb 0987654321
 --   --   --   --   --   --        --   --       
|  | |  | |  |    | |    |    |  |    |    |    | 
|  | |  | |  |    | |    |    |  |    |    |    | 
      --   --        --   --   --   --   --       
|  |    | |  |    | |  |    |    |    | |       | 
|  |    | |  |    | |  |    |    |    | |       | 
 --   --   --        --   --        --   --       
[2015Feb17 19:41:54] lcd_number_gen $ ruby lcd.rb -s 1 0987654321
 -   -   -   -   -   -       -   -      
| | | | | |   | |   |   | |   |   |   | 
     -   -       -   -   -   -   -      
| |   | | |   | | |   |   |   | |     | 
 -   -   -       -   -       -   -      

Original pseudocode:

# #chars to split arg digits into digits
# If size 1 print each square with one each of '-' and '|' and one space between numbers
# For size x print each square with x each of '-' and '|' and one space between numbers

Some methods I considered:

# printf("%{foo} %{bar}", { foo: "-" , bar: "|" }) => - |
# sprintf("%{foo} %{bar}", { foo: "-" , bar: "|" }) => "- |"
# width1 = 10 , width 2 = 5
# printf "%#{width1}s %#{width2}s", "-", "|"
# =>          -     | 
# sprintf "%#{width1}s %#{width2}s", "-", "|"
# => "          -     | "
# printf "%#{width1}s %#{width2}s",( "-" * 2 ), ( "|" * 2 )
# =>         --    || 
# ("--").center(2*2) => " -- " 
# ("  ").center(2*2, "|") => "|  |"
# similarly for #ljust and #rjust
# use print and assign output field separator ($,) $, = " "

# Some of the methods used in the final solution prior to refactoring:

def print_blank
  print (" " * @height).center(@height + 2) # print " " , " " * @height, " "		
end

def print_horizontal_line
  print ("-" * @height).center(@height + 2) # print " " , "-" * @height, " "
end

def print_left_vertical
  print "|"
  @height.times { print " " }
  print " "
end

def print_left_and_right
  print "|"
  @height.times { print " " }
  print "|"
end

def print_left_and_right
  print (' ' * @height).center(@height + 2 , '|')
end

class LcdPrinter < LcdGenerator
	
  def initialize(number, height)
    super
  end

=end
