/* Initial beliefs and rules */

/* Initial goals */
!book_dentist(15).


/* Plans */
+!book_dentist(Time) <- .send(assistant, achieve, book_dentist(Time)); .wait(1000); .send(assistant, tell, blocked(15)); .wait(5000); .send(assistant, untell, blocked(15)).
			