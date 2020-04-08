/* Macro to start N sessions with the CAS statement */
%macro start_sess(n);
  %do i = 1 %to &n;
    cas sess&i host="my-cas-server.sas.com" port=5570;
  %end;
%mend;

/* Macro to stop N sessions that were started with %start_sess */
%macro stop_sess(n);
  %do i = 1 %to &n;
    cas sess&i terminate;
  %end;
%mend;

/*** CHANGE to number of concurrent loadTables you want to run ***/
%let n_sessions=5;

%start_sess(&n_sessions);

/* CASL code to run actions in parallel */
proc cas;
  
  /* Function that does processing we need.                         */
  /* Actions must use session= and async= so that we assign the     */
  /*  action to a session and we don't block waiting for the action */
  /*  to complete.                                                  */
  function process_stuff(sess, item);
    print "*** Starting Item:"item "in " sess " ***";

    /* Sleep for a bit to simulate processing */
    dataStep.runCode session=sess async=("Item:"||item) /
      code="data _null_; x=sleep(" || (item*1000) || ");";
  end;

  /* Array of stuff to process */
  process_these = {5 4 6 8 2 1 9 3 7 2 1 9 4 5};

  /* Array of sessions to use */
  if &n_sessions = 1 then
    sessions = ${sess1};
  else
    sessions = ${sess1 - sess&n_sessions};

  /* Give something to process to each session */
  do sess over sessions;
    if dim(process_these) = 0 then leave;

    /* Get something to process and remove from array */    
    item = process_these[1];
    process_these = process_these[!{1}];

    process_stuff(sess, item);
  end;
  run;

  /* When processing in a session finishes, start processing */
  /*  something new in that session until we've processed    */
  /*  all elements in process_these.                         */
  do while(dim(process_these) != 0);
    job = wait_for_next_action(0);
    print "*** Finished " job.job " in " job.session " ***";
    /* print job.logs; */
    
    /* Get something to process and remove from array */    
    item = process_these[1];
    process_these = process_these[!{1}];

    process_stuff(job.session, item);
  end;
  run;

  /* Wait for all outstanding processing to finish */
  job = wait_for_next_action(0);
  do while (job);
    print "*** Finished " job.job " in " job.session " ***";
    /* print job.logs; */
    job = wait_for_next_action(0);
  end;
  run;
quit;

%stop_sess(&n_sessions);
