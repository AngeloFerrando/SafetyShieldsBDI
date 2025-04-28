/* Initial beliefs and rules */

/* Initial goals */
blocked([9,9.30,10,10.30,11,11.30,12,12.30,13,13.30,14,14.30]).

/* Plans */
+!book_dentist(Time) : blocked(ListTime) & not .member(Time,ListTime) 
	<- 
		.send(dentist, achieve, booking(15));
		.wait({+dentist_confirmation});
		.print("Booking successful!").			
			
+blocked(Time) <- .print("Blocked time added: ",Time); .suspend(book_dentist(15)).
-blocked(Time) <- .print("Blocked time remove: ",Time); .resume(book_dentist(15)).