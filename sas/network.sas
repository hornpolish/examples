

options cashost="el01cn08.unx.sas.com" casport=5570;
cas ;

proc cas noqueue;
setsessopt / metrics=true;

dropcaslib / caslib="sna";
addcaslib / caslib="sna" datasource={srctype="path"} path="/bigdisk/lax/magala" session=false;
loadtable / caslib="sna" path="orkut" importoptions={filetype="basesas", dtm="parallel"};

sampling.srs       / sampPct=0.10 table="orkut" output = {casOut={name="orkut_samp10", replace=true replication=0}, copyVars="all"};
network.centrality / logLevel="aggressive" links = {name = "orkut_samp10"} outNodes = {name = "OutNodes10", replace=true} between="unweight";

sampling.srs       / sampPct=0.15 table="orkut" output = {casOut={name="orkut_samp15", replace=true replication=0}, copyVars="all"};
network.centrality / logLevel="aggressive" links = {name = "orkut_samp15"} outNodes = {name = "OutNodes15", replace=true} between="unweight";

sampling.srs       / sampPct=0.20 table="orkut" output = {casOut={name="orkut_samp20", replace=true replication=0}, copyVars="all"};
network.centrality / logLevel="aggressive" links = {name = "orkut_samp20"} outNodes = {name = "OutNodes20", replace=true} between="unweight";


/* now make 3 sessions, run the different sample-percentage "tasks" in parallel */

cas s1;
cas s2;
cas s3;

cas casauto; /* back to default session */

sampling.srs       session="s1" async="s1" / sampPct=0.10 table="orkut" output = {casOut={name="orkut_samp10", replace=true replication=0}, copyVars="all"};
network.centrality session="s1" async="s1" / logLevel="aggressive" links = {name = "orkut_samp10"} outNodes = {name = "OutNodes10", replace=true} between="unweight";

sampling.srs       session="s2" async="s2" / sampPct=0.15 table="orkut" output = {casOut={name="orkut_samp15", replace=true replication=0}, copyVars="all"};
network.centrality session="s2" async="s2" / logLevel="aggressive" links = {name = "orkut_samp15"} outNodes = {name = "OutNodes15", replace=true} between="unweight";

sampling.srs       session="s3" async="s3" / sampPct=0.20 table="orkut" output = {casOut={name="orkut_samp20", replace=true replication=0}, copyVars="all"};
network.centrality session="s3" async="s3" / logLevel="aggressive" links = {name = "orkut_samp20"} outNodes = {name = "OutNodes20", replace=true} between="unweight";


;; job = wait_for_next_action(0);
;; do while (job);
;;;; print "*** " job.job " ***";
;;;; print job.logs;
;;;; job = wait_for_next_action(0);
;; end;
;; run;