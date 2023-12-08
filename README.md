```
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/K8OywbE8)
# CSE220_HW7

MIPS Programming  


SBU ID#  112555537


Name:  Jason Bokinz


Test cases for each part  

Part A:

Test Case: 1
Input:  Triangle(0) or Square(1) or Pyramid(2)? 2
        Required size? 10

Output:

          * 
         * * 
        * * * 
       * * * * 
      * * * * * 
     * * * * * * 
    * * * * * * * 
   * * * * * * * * 
  * * * * * * * * * 
 * * * * * * * * * *

Test Case: 2
Input: Triangle(0) or Square(1) or Pyramid(2)? 3

Output: Error: Shape does not exist.

Test Case 3:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 1
        Required size? 0

Output: Error: Size must be greater than zero.

Test Case 4:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 1
        Required size? 5

Output: 

*****
*****
*****
*****
*****

Test Case 5:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 0
        Required size? 2

Output:

*
**

Test Case 6:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 2
        Required size? 4

Output: 

    * 
   * * 
  * * * 
 * * * *

Test Case 7:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 1
        Required size? 7

Output:

*******
*******
*******
*******
*******
*******
*******

Test Case 8:
Input: Triangle(0) or Square(1) or Pyramid(2)? 0
        Required size? 6

Output:

*
**
***
****
*****
******

Test Case 9:
Input: Triangle(0) or Square(1) or Pyramid(2)? 2
        Required size? 8

Output: 

        * 
       * * 
      * * * 
     * * * * 
    * * * * * 
   * * * * * * 
  * * * * * * * 
 * * * * * * * * 

Test Case 10:
Input:  Triangle(0) or Square(1) or Pyramid(2)? 0
        Required size? 7    

Output:

*
**
***
****
*****
******
*******


Part B:

Test Case 1:
Input:  # When num = 10
A[1]=1
B[1]=2
A[2]=3
B[2]=4
A[3]=5
B[3]=6
A[4]=7
B[4]=8
A[5]=9
B[5]=10
A[6]=11
B[6]=12
A[7]=13
B[7]=14
A[8]=15
B[8]=16
A[9]=17
B[9]=18
A[10]=19
B[10]=20

Output: 2 1|4 3|6 5|8 7|10 9|12 11|14 13|16 15|18 17|20 19|

Test Case 2:
Input:  # When num = 101

Output: Error: Element size too large.

Test Case 3:
Input:  # When numm = 5
A[1]=4
B[1]=2
A[2]=5
B[2]=8
A[3]=10
B[3]=13
A[4]=7
B[4]=11
A[5]=20
B[5]=4

Output: 2 4|8 5|13 10|11 7|4 20|

Test Case 4:
Input:  # When num <= 0

Output: Error: Element size too small.

Test Case 5:
Input;  # When num = 1

Output: 5 10|

Test Case 6:
Input:  # when num = 4
A[1]=5
B[1]=10
A[2]=100
B[2]=69
A[3]=23
B[3]=12
A[4]=44
B[4]=23

Output: 10 5|69 100|12 23|23 44|

Test Case 7:
Input:  # when num = 7
A[1]=1
B[1]=54
A[2]=2
B[2]=889
A[3]=54
B[3]=112
A[4]=76
B[4]=34
A[5]=21
B[5]=34
A[6]=90
B[6]=21
A[7]=33
B[7]=26

Output: 54 1|889 2|112 54|34 76|34 21|21 90|26 33|

Test Case 8:
Input:  # when num = 2
A[1]=33
B[1]=74
A[2]=421
B[2]=69

Output: 74 33|69 421|

Test Case 9:
Input:  # when num = 8
A[1]=234
B[1]=567
A[2]=22
B[2]=76
A[3]=11
B[3]=3
A[4]=0
B[4]=34
A[5]=55
B[5]=75
A[6]=34
B[6]=32
A[7]=56
B[7]=99
A[8]=1
B[8]=0

Output:
567 234|76 22|3 11|34 0|75 55|32 34|99 56|0 1|

Test Case 10:
Input:  # when num = 3
A[1]=6
B[1]=-5
A[2]=4
B[2]=3
A[3]=2
B[3]=1

Output: -5 6|3 4|1 2|


Part C:

Test Case 1:
Input:  # when col_m = 3, row_m = 2, col_v = 1, and row_v = 2

Output: NOT WORKABLE BECAUSE OF THE DIMENSIONS

Test Case 2:
Input:  # when col_m = 100, row_m = 2, col_v = 1, and row_v = 100

Output: NOT WORKABLE BECAUSE OF THE MEMORY

Test Case 3: 
Input:  # when col_m = 51, row_m = 2, col_v = 1, and row_v = 51

Output: NOT WORKABLE BECAUSE OF THE MEMORY

Test Case 4:
Input:  # when col_m = 3, row_m = 3, col_v = 1, and row_v = 3
Enter Matrix element 1 = 1
Enter Matrix element 2 = 2
Enter Matrix element 3 = 3
Enter Matrix element 4 = 4
Enter Matrix element 5 = 5
Enter Matrix element 6 = 6
Enter Matrix element 7 = 7
Enter Matrix element 8 = 8
Enter Matrix element 9 = 9
------------------------------------------
Enter Vector element 1 = 1
Enter Vector element 2 = 2
Enter Vector element 3 = 3

Output: Resulting Vector = [14, 32, 50]

Test Case 5:
Input : # when col_m = 2, row_m = 1, col_v = 1, and row_v = 2
Enter Matrix element 1 = 10
Enter Matrix element 2 = 22
------------------------------------------
Enter Vector element 1 = 43
Enter Vector element 2 = 5

Output: Resulting Vector = [540]

Test Case 6:
Input: # when col_m = 2, row_m = 3, col_v = 1, and row_v = 2
Enter Matrix element 1 = 30
Enter Matrix element 2 = 24
Enter Matrix element 3 = 11
Enter Matrix element 4 = 88
Enter Matrix element 5 = 3
Enter Matrix element 6 = 42
------------------------------------------
Enter Vector element 1 = 90
Enter Vector element 2 = 3

Output: Resulting Vector = [2772, 1254, 396]

Test Case 7:
Input:  # when col_m = 1, row_m = 3, col_v = 1, and row_v = 1
Enter Matrix element 1 = 21
Enter Matrix element 2 = 34
Enter Matrix element 3 = 77
------------------------------------------
Enter Vector element 1 = 12

Output: Resulting Vector = [252, 408, 924]

Test Case 8:
Input:  # when col_m = 4, row_m = 2, col_v = 1, and row_v = 4
Enter Matrix element 1 = -21
Enter Matrix element 2 = 32
Enter Matrix element 3 = -7
Enter Matrix element 4 = 11
Enter Matrix element 5 = 45
Enter Matrix element 6 = 1
Enter Matrix element 7 = 100
Enter Matrix element 8 = -3
------------------------------------------
Enter Vector element 1 = 2
Enter Vector element 2 = 32
Enter Vector element 3 = 4
Enter Vector element 4 = 4

Output: Resulting Vector = [998, 510]

Test Case 9:
Input:  # when col_m = 1, row_m = 1, col_v = 1, and row_v = 1
Enter Matrix element 1 = -5
------------------------------------------
Enter Vector element 1 = 2

Output: Resulting Vector = [-10]

Test Case 10:
Input:  # when col_m = 2, row_m = 4, col_v = 1, and row_v = 2
Enter Matrix element 1 = 3
Enter Matrix element 2 = 5
Enter Matrix element 3 = 21
Enter Matrix element 4 = 33
Enter Matrix element 5 = 412
Enter Matrix element 6 = 9
Enter Matrix element 7 = 11
Enter Matrix element 8 = -3
------------------------------------------
Enter Vector element 1 = 2
Enter Vector element 2 = 0

Output: Resulting Vector = [6, 42, 824, 22]

```