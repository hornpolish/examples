%let sysparm=runcas:laxsmp;
%cassetup;

cas sess1;
cas sess2;
cas sess3;
cas sess4;
cas sess5;
cas sess6;

proc cas;
;; do sess over {"sess1" "sess2" "sess3" "sess4" "sess5" "sess6"};
;;;; about session=sess async=sess;
;; end;

;; job = wait_for_next_action(0);
;; do while (job);
;;;; print "*** " job.job " ***";
;;;; print job.logs;
;;;; job = wait_for_next_action(0);
;; end;
;; run;
quit;

cas _all_ terminate;
%casclear(stop=yes);