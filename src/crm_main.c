//	crm_main.c - main interface

// Copyright 2001-2009 William S. Yerazunis.
// This file is under GPLv3, as described in COPYING.

//  include some standard files
#include "crm114_sysincludes.h"
//  include any local crm114 configuration file
#include "crm114_config.h"

//  include the crm114 data structures file
#include "crm114_structs.h"

//  include the routine declarations file
#include "crm114.h"

//  and include OSBF declarations
#include "crm114_osbf.h"

//    the command line argv
char **prog_argv;

//    the auxilliary input buffer (for WINDOW input)
char *newinputbuf;

//    the globals used when we need a big buffer  - allocated once, used
//    wherever needed.  These are sized to the same size as the data window.
char *inbuf;
char *outbuf;
char *tempbuf;

long vht_size = DEFAULT_VHT_SIZE;
long cstk_limit = DEFAULT_CSTK_LIMIT;
long max_pgmlines = DEFAULT_MAX_PGMLINES;
long max_pgmsize = DEFAULT_MAX_PGMLINES * 128;
long data_window_size = DEFAULT_DATA_WINDOW;
long user_trace = DEFAULT_USER_TRACE_LEVEL;
long internal_trace = DEFAULT_INTERNAL_TRACE_LEVEL;
long sparse_spectrum_file_length = 0;
long microgroom_chain_length = 0;
long microgroom_stop_after = 0;
float min_pmax_pmin_ratio = OSBF_MIN_PMAX_PMIN_RATIO;
long ignore_environment_vars = 0;
long debug_countdown = -1;
long cycle_counter = 0;
long cmdline_break = -1;
long profile_execution = 0;
long prettyprint_listing = 0;
long engine_exit_base = 0;
long q_expansion_mode = 0;
int dontcare = 0;
void *dontcareptr;
VHT_CELL **vht;
CSL_CELL *csl;
CSL_CELL *cdw;
CSL_CELL *tdw;
CSL_CELL *mdw;
ARGPARSE_BLOCK *apb;


int main (int argc, char **argv)
{
  int i;    //  some random counters, when we need a loop
  int status;
  int openbracket;  //  if there's a command-line program...
  int openparen = -1;     //  if there's a list of acceptable arguments
  int user_cmd_line_vars = 0;  // did the user specify --vars on cmdline?

  //  printf (" args: %d \n", argc);
  //  for (i = 0; i < argc; i++)
  //    fprintf (stderr, " argi: %d, argv: %s \n", i, argv[i]);

  //   copy argv into global statics...
  prog_argv = argv;

  //    allcate and initialize the initial root csl (control stack
  //    level) cell.  We do this first, before command-line parsing,
  //    because the command line parse fills in a lot of the first level csl.

  csl = (CSL_CELL *) malloc (sizeof (CSL_CELL));
  if (!csl)
    untrappableerror5 ("Couldn't malloc the csl.  Big problem!\n",
		       "", CRM_ENGINE_HERE);
  csl -> filename = NULL;
  csl -> filedes = -1;
  csl -> rdwr = 0;   //  0 means readonly, 1 means read/write
  csl -> nchars = 0;
  csl -> mct = 0;
  csl -> cstmt = 0;
  csl -> nstmts = 0;
  csl -> preload_window = 1;
  csl -> caller = NULL;
  csl -> calldepth = 0;
  csl -> aliusstk[0]  = 0;  // this gets initted later.

  openbracket = -1;
  openparen = -1;

  //   and allocate the argparse block
  apb = (ARGPARSE_BLOCK *) malloc (sizeof (ARGPARSE_BLOCK));
  if (!apb)
    untrappableerror5 ("Couldn't malloc apb.  This is very bad.\n",
		       "", CRM_ENGINE_HERE);

  //   Parse the input command arguments

  //  user_trace = 1;
  //internal_trace = 1;

  for (i = 1; i < argc; i++)
    {
      // fprintf (stderr, "Arg %d = '%s' \n", i, argv[i]);
      //   is this a plea for help?
      if (
	  (strncmp (argv[i], "-?", 2) == 0)
	  || (strncmp (argv[i], "-h", 2) == 0)
	  || (argc == 1) )
	{
	  fprintf (stderr, " CRM114 version %s (regex engine: %s)\n ",
		   VERSION,
		   crm_regversion());
	  fprintf (stderr, " Copyright 2001-2009 William S. Yerazunis\n");
	  fprintf (stderr, " This software is licensed under the GPL "
		   "with ABSOLUTELY NO WARRANTY\n");
	  fprintf (stderr, "     For language help, RTFRM. \n");
	  fprintf (stderr, "     Command Line Options:\n");
	  fprintf (stderr, " -{statements}   executes statements\n");
	  fprintf (stderr, " -b nn   sets a breakpoint on stmt nn\n");
	  fprintf (stderr, " -d nn   run nn statements, then drop to debug\n");
	  fprintf (stderr, " -e      ignore environment variables\n");
	  fprintf (stderr, " -E      set base for engine exit values\n");
	  fprintf (stderr, " -h      this help\n");
	  fprintf (stderr, " -l n    listing (detail level 1 through 5)\n");
	  fprintf (stderr, " -m nn   max number of microgroomed buckets in a chain\n");
	  fprintf (stderr, " -M nn   max chain length - triggers microgrooming if enabled\n");
	  fprintf (stderr, " -p      profile statement times \n");
	  fprintf (stderr, " -P nn   max program lines @ 128 chars/line\n");
	  fprintf (stderr, " -q m    mathmode (0,1 alg/RPN in EVAL,"
		   "2,3 alg/RPN everywhere)\n");
	  fprintf (stderr, " -r nn   set OSBF min pmax/pmin ratio (default=9)\n");
	  fprintf (stderr, " -s nn   sparse spectra (.css) featureslots \n");
	  fprintf (stderr, " -S nn   round up to 2^N+1 .css featureslots \n");
	  fprintf (stderr, " -C      use env. locale (default POSIX)\n");
	  fprintf (stderr, " -t      user trace mode on\n");
	  fprintf (stderr, " -T      implementors trace mode on\n");
	  fprintf (stderr, " -u dir  chdir to directory before starting\n");
	  fprintf (stderr, " -v      print version ID and exit \n");
	  fprintf (stderr, " -w nn   max data window size ( bytes ) \n");
	  fprintf (stderr, " --      end of CRM114 flags; start of user args\n");
	  fprintf (stderr, " --foo   creates var :foo: with value 'SET'\n");
	  fprintf (stderr, " --x=y   creates var :x: with value 'y'\n");
	  if (openparen > 0)
	    {
	      fprintf (stderr, "\n This program also claims to accept these command line args:" );
	      fprintf (stderr, "\n  %s\n", &argv[openparen][1] );
	    };
	  if (engine_exit_base != 0)
	    {
	      exit (engine_exit_base + 14);
	    }
	  else
	    exit (EXIT_SUCCESS);
	}

      //  -- means "end of crm114 flags" - remainder of args goes to
      //  the program alone.
      if (strncmp (argv[i], "--", 2) == 0  && strlen (argv[i]) == 2)
	{
	  if (user_trace > 0)
	    fprintf (stderr, "system flag processing ended at arg %d .\n", i);
	  i = argc;
	  goto end_command_line_parse_loop;
	}
      if (strncmp (argv[i], "--", 2) == 0 && strlen (argv[i]) > 2)
	{
	  if (user_trace > 0)
	    fprintf (stderr, "Commandline set of user variable at %d '%s'.\n",
		     i, argv[i]);
	  if (user_cmd_line_vars == 0) user_cmd_line_vars = i;
	  goto end_command_line_parse_loop;
	};
      //   set debug levels
      if (strncmp (argv[i], "-t", 2) == 0 && strlen(argv[i]) == 2)
	{
	  user_trace++;
	  if (user_trace > 0)
	    {
	      fprintf (stderr, "Setting usertrace level to %ld\n", user_trace);
	    };
	  goto end_command_line_parse_loop;
	};

      if (strncmp (argv[i], "-T", 2) == 0 && strlen(argv[i]) == 2)
	{
	  internal_trace++;
	  if (user_trace > 0 )
	  fprintf (stderr, "Setting internaltrace to %ld\n", internal_trace);
	  goto end_command_line_parse_loop;
	};

      if (strncmp (argv[i], "-p", 2) == 0 && strlen(argv[i]) == 2)
	{
	  profile_execution = 1;
	  if (user_trace > 0 )
	    fprintf (stderr, "Setting profile_execution to 1" );
	  goto end_command_line_parse_loop;
	};

      //   is this a change to the maximum number of program lines?
      if (strncmp (argv[i], "-P", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    {
	      sscanf (argv[i], "%ld", &max_pgmlines);
	      max_pgmsize = 128 * max_pgmlines;
	    }
	  if (user_trace > 0)
	    fprintf (stderr, "Setting max prog lines to %ld (%ld bytes)\n",
		     max_pgmlines, max_pgmsize);
	  goto end_command_line_parse_loop;
	};

      //   is this a "gimme a listing" flag?
      if (strncmp (argv[i], "-l", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    {
	      sscanf (argv[i], "%ld", &prettyprint_listing);
	    }
	  if (user_trace > 0)
	    fprintf (stderr, "Setting listing level to %ld \n",
		     prettyprint_listing);
	  goto end_command_line_parse_loop;
	};

      //   is this a "Use Local Country Code" flag?
      if (strncmp (argv[i], "-C", 2) == 0 && strlen(argv[i]) == 2)
	{
	  if (user_trace > 0)
	    fprintf (stderr, "Setting locale to local\n");
	  setlocale (LC_ALL, "");
	  goto end_command_line_parse_loop;
	};

      //   is this a change to the math mode (0,1 for alg/RPN but only in EVAL,
      //   2,3 for alg/RPN everywhere.
      if (strncmp (argv[i], "-q", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%ld", &q_expansion_mode);
	  if (user_trace > 0)
	    {
	      fprintf (stderr, "Setting math mode to %ld ", q_expansion_mode);
	      if (q_expansion_mode == 0)
		fprintf (stderr, "(algebraic, only in EVAL\n");
	      if (q_expansion_mode == 1)
		fprintf (stderr, "(RPN, only in EVAL\n");
	      if (q_expansion_mode == 2)
		fprintf (stderr, "(algebraic, in all expressions)\n");
	      if (q_expansion_mode == 3)
		fprintf (stderr, "(RPN, in all expressions)\n");
	    };
	  goto end_command_line_parse_loop;
	};

      //   change the size of the maximum data window we'll allow
      if (strncmp (argv[i], "-w", 2) == 0 && strlen(argv[i]) == 2)
       {
         i++;    // move to the next arg
         if (i < argc)
           sscanf (argv[i], "%ld", &data_window_size);
         if (data_window_size < 8192)
           {
             fprintf (stderr, "Sorry, but the min data window is 8192 bytes");
             data_window_size = 8192;
           };
         if (user_trace > 0)
           fprintf (stderr, "Setting max data window to %ld chars\n",
                    data_window_size);
         goto end_command_line_parse_loop;
       };

      //   change the size of the sparse spectrum file default.
      if (strncasecmp (argv[i], "-s", 2) == 0 && strlen(argv[i]) == 2)
        {
          i++;    // move to the next arg
	  if (i < argc &&
	      sscanf (argv[i], "%ld", &sparse_spectrum_file_length))
	    {
	      if (strcmp (argv[i-1], "-S") == 0)
		{
		  long k;

		  k=(long) floor(log10(sparse_spectrum_file_length-1)
				 / log10(2));
		  while ( (2<<k)+1 < sparse_spectrum_file_length)
		    {
		      k++;
		    };
		  sparse_spectrum_file_length=(2<<k)+1;
		};
            }
	  else
	    {
	      fprintf (stderr, "On -s flag: Missing or incomprehensible"
		       ".CSS file length.\n");
	      if (engine_exit_base != 0)
		{
		  exit (engine_exit_base + 15);
		}
	      else
		exit (EXIT_FAILURE);
	    };

	  if (user_trace > 0)
	    fprintf (stderr, "Setting sparse spectrum length to %ld bins\n",
		     sparse_spectrum_file_length );
	  goto end_command_line_parse_loop;
	};

      //   set a break from the command line
      if (strncmp (argv[i], "-b", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%ld", &cmdline_break);
	  if (user_trace > 0)
	    fprintf (stderr, "Setting the command-line break to line %ld\n",
		     cmdline_break);
	  goto end_command_line_parse_loop;
	};

      //   set base value for detailed engine exit values
      if (strncmp (argv[i], "-E", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%ld", &engine_exit_base);
	  if (user_trace > 0)
	    fprintf (stderr, "Setting the engine exit base value to %ld\n",
		     engine_exit_base);
	  goto end_command_line_parse_loop;
	};

      //   set countdown cycles before dropping to debugger
      if (strncmp (argv[i], "-d", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  debug_countdown = 0;
	  if (i < argc)
	    sscanf (argv[i], "%ld", &debug_countdown);
	  if (user_trace > 0)
	    fprintf (stderr, "Setting debug countdown to %ld statements\n",
		     debug_countdown);
	  if (debug_countdown == 0)   //  if next arg wasn't numeric, back up
	    i-- ;
	  goto end_command_line_parse_loop;
	};

      //   ignore environment variables?
      if (strncmp (argv[i], "-e", 2) == 0 && strlen(argv[i]) == 2)
	{
	  ignore_environment_vars++;
	  if (user_trace > 0)
	    fprintf (stderr, "Ignoring environment variables\n");
	  goto end_command_line_parse_loop;
	};

      // is this to set the cwd?
      if (strncmp (argv[i], "-u", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
          if (user_trace)
	    fprintf (stderr, "Setting WD to %s\n",argv[i]);
          if ( i >= argc )
	    {
	      fprintf (stderr, "The -u working-directory change needs an arg");
	      goto end_command_line_parse_loop;
	    };
	  if ( chdir(argv[i] ))
	    {
	      fprintf (stderr, "Sorry, couldn't chdir to %s \n", argv[i]);
	    };
	  goto end_command_line_parse_loop;
	};

      if (strncmp (argv[i], "-v", 2) == 0 && strlen(argv[i]) == 2)
	{
	  //   NOTE - version info goes to stdout, not stderr, just like GCC does
	  fprintf (stdout,
		   " This is CRM114, version %s (%s)\n",
		   VERSION,
		   crm_regversion());
	  fprintf (stdout, " Copyright 2001-2009 William S. Yerazunis\n");
	  fprintf (stdout, " This software is licensed under the GPL with ABSOLUTELY NO WARRANTY\n");
	  if (engine_exit_base != 0)
	    {
	      exit (engine_exit_base + 16);
	    }
	  else
	    exit( EXIT_SUCCESS );
	};

      if (strncmp (argv[i], "-{", 2) == 0)  //  don't care about the "}"
	{
	  if (user_trace)
	    fprintf (stderr, "Command line program at arg %d\n", i);
	  openbracket = i;
	  goto end_command_line_parse_loop;
	};

      //
      //      What about -( var var var ) cmdline var restrictions?
      if (strncmp (argv[i], "-(", 2) == 0 )
	{
	  if (user_trace)
	    fprintf (stderr, "Allowed command line arg list at arg %d\n", i);
	  openparen = i;
	  //
	  //      If there's a -- at the end of the arg, lock out system
	  //      flags as though we hit a '--' flag.
	  //      (i.e. no debugger.  Minimal security. No doubt this is
	  //      circumventable by a sufficiently skilled user, but
	  //      at least it's a start.)
	  if ( strncmp ("--", &argv[i][strlen(argv[i])-2], 2) == 0)
	    {
	      if (user_trace)
		fprintf (stderr, "cmdline arglist also locks out sysflags.\n");
	      i = argc;
	    };
	  goto end_command_line_parse_loop;
	};

      //   set microgroom_stop_after
      if (strncmp (argv[i], "-m", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%ld", &microgroom_stop_after);
	  if (user_trace > 0)
	    fprintf (stderr, "Setting microgroom_stop_after to %ld\n",
		     microgroom_stop_after);
	  if (microgroom_stop_after <= 0)   //  if value <= 0 set it to default
	    microgroom_stop_after = MICROGROOM_STOP_AFTER;
	  goto end_command_line_parse_loop;
	};

      //   set microgroom_chain_length length
      if (strncmp (argv[i], "-M", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%ld", &microgroom_chain_length);
	  if (user_trace > 0)
	    fprintf (stderr, "Setting microgroom_chain_length to %ld\n",
		     microgroom_chain_length);
	  if (microgroom_chain_length < 5)   //  if value <= 5 set it to default
	    microgroom_chain_length = MICROGROOM_CHAIN_LENGTH;
	  goto end_command_line_parse_loop;
	};

      //   set min_pmax_pmin_ratio
      if (strncmp (argv[i], "-r", 2) == 0 && strlen(argv[i]) == 2)
	{
	  i++;    // move to the next arg
	  if (i < argc)
	    sscanf (argv[i], "%f", &min_pmax_pmin_ratio);
	    if (user_trace > 0)
	      fprintf (stderr, "Setting min pmax/pmin of a feature to %f\n",
		min_pmax_pmin_ratio);
	  if (min_pmax_pmin_ratio < 0)   //  if value < 0 set it to 0
	    min_pmax_pmin_ratio = OSBF_MIN_PMAX_PMIN_RATIO ;
	  goto end_command_line_parse_loop;
        };

      //  that's all of the flags.  Anything left must be
      //  the name of the file we want to use as a program
      //  BOGOSITUDE - only the FIRST such thing is the name of the
      //  file we want to use as a program.  The rest of the args
      //  should just be passed along
      if (csl->filename == NULL)
	{
          if (strlen(argv[i]) > MAX_FILE_NAME_LEN)
	    untrappableerror5 ("Invalid filename, ",
			       "filename too long.", CRM_ENGINE_HERE);
	  csl->filename = argv[i];
	  if (user_trace > 0)
	    fprintf (stderr, "Using program file %s\n", csl->filename);
	};
    end_command_line_parse_loop:
      if (internal_trace)
	fprintf (stderr, "End of pass %d through cmdline parse loop\n",
		 i);
    }

  //  main2 ();

  //
  //     Did we get a program filename?  If not, look for one.
  //     At this point, accept any arg that doesn't start with a - sign
  //
  if (csl->filename == NULL && openbracket < 1)
    {
      if (internal_trace)
	fprintf (stderr, "Looking for _some_ program to run...\n");
      for (i = 1; i < argc; i++)
	if (argv[i][0] != '-')
	  {
           if (strlen(argv[i]) > MAX_FILE_NAME_LEN)
	     untrappableerror5 ("Couldn't open the file, ",
				"filename too long.", CRM_ENGINE_HERE);
	   csl->filename = argv[i];
	   i = argc;
	  }
      if (user_trace > 0)
	fprintf (stderr, "Using program file %s\n", csl->filename);
    };
  //      If we still don't have a program, we're done.  Squalk an
  //      error.
  if (csl->filename == NULL && openbracket < 0)
    {
      fprintf (stderr, "\nCan't find a file to run,"
	       "or a command-line to execute. \n"
	       "I give up... (exiting)\n");
      if (engine_exit_base != 0)
	{
	  exit (engine_exit_base + 17);
	}
      else
	exit (EXIT_SUCCESS);
    };

  //     open, stat and load the program file
  if (openbracket < 0 )
    {
      {
	if (argc <= 1)
	  {
	    fprintf (stderr, "CRM114 version %s \n", VERSION);
	    fprintf (stderr, "Try 'crm <progname>', or 'crm -h' for help\n");
	    if (engine_exit_base != 0)
	      {
		exit (engine_exit_base + 18);
	      }
	    else
	      exit (EXIT_SUCCESS);
	  }
	else
	  {
	    if (user_trace)
	      fprintf (stderr, "Loading program from file %s\n",
		       csl->filename);
	    crm_load_csl (csl);
	  };
      };
    }
  else
    {
      //   if we got here, then it's a command-line program, and
      //   we should just assemble the proggie from the argv [openbracket]
      if (strlen (&(argv[openbracket][1])) + 2048 > max_pgmsize)
	untrappableerror5 ("The command line program is too big. \n",
			   "Try increasing the max program size with -P. \n",
			   CRM_ENGINE_HERE);
      csl->filename = "(from command line)";
      csl->filetext = (char *) malloc (sizeof (char) * max_pgmsize);
      if (!csl->filetext)
	untrappableerror5
	  ("Couldn't malloc csl->filetext space (where I was going to put your program.\nWithout program space, we can't run.  Sorry.",
	   "", CRM_ENGINE_HERE);
      strcpy (csl->filetext, "\n");
      //     the [1] below gets rid of the leading - sign
      strcat (csl->filetext, &(argv[openbracket][1]));
      strcat (csl->filetext, "\n");
      strcat (csl->filetext, "\n");
      csl->nchars = strlen (csl->filetext);
      csl->hash = strnhash (csl->filetext, csl->nchars);
      if (user_trace)
	fprintf (stderr, "Hash of program: %X, length is %ld bytes\n",
		 csl->hash, csl->nchars);
    };

  //  We get another csl-like data structure,
  //  which we'll call the cdw, which has all the fields we need, and
  //  simply allocate the data window of "adequate size" and read
  //  stuff in on stdin.

  cdw = malloc (sizeof (CSL_CELL));
  if (!cdw)
    untrappableerror5 ("Couldn't malloc cdw.\nThis is very bad.","",
		       CRM_ENGINE_HERE);
  cdw->filename = NULL;
  cdw->rdwr = 1;
  cdw->filedes = -1;
  cdw->filetext = malloc (sizeof (char) * data_window_size);
  if (!cdw->filetext)
    untrappableerror5 ("Couldn't malloc cdw->filetext.\nWithout this space, you have no place for data.  Thus, we cannot run.","", CRM_ENGINE_HERE);
  //      also allocate storage for the windowed data input
  newinputbuf = malloc (sizeof (char) * data_window_size);

  //      and our three big work buffers - these are used ONLY inside
  //      of a single statement's execution and do NOT ever contain state
  //      that has to exist across statements.
  inbuf = malloc (sizeof (char) * data_window_size);
  outbuf = malloc (sizeof (char) * data_window_size);
  tempbuf = malloc (sizeof (char) * data_window_size);
  if (!tempbuf || !outbuf || !inbuf || !newinputbuf)
    untrappableerror5 (
		      "Couldn't malloc one or more of"
		      "newinputbuf,inbuf,outbuf,tempbuf.\n"
		      "These are all necessary for operation."
                      "We can't run.","", CRM_ENGINE_HERE);

  //     Initialize the VHT, add in a few predefined variables
  //
  crm_vht_init(argc, argv);

  //    Call the pre-processor on the program
  //
  status = crm_preprocessor (csl, 0);

  //    Now, call the microcompiler on the program file.
  status = crm_microcompiler ( csl, vht);
  //    Great - program file is now mapped via csl->mct

  //    Put a copy of the preprocessor-result text into
  //    the isolated variable ":_pgm_text:"
  crm_set_temp_var (":_pgm_text:", csl->filetext);

  //  If the windowflag == 0, we should preload the data window.  Now,
  //  let's get some data in.

  //    and preload the data window with stdin until we hit EOF
  i = 0;
  if (csl->preload_window)
    {
      //     GROT GROT GROT  This is slow
      //
      //while (!feof (stdin) && i < data_window_size - 1)
      //	{
      //	  cdw->filetext[i] = fgetc (stdin);
      //	  i++;
      //	};
      //i-- ;  //     get rid of the extra ++ on i from the loop; this is the
      //            EOF "character" which prints like an umlauted-Y.
      //
      //
      //         This is the much faster way.
      //
      //      i = fread (cdw->filetext, 1, data_window_size -1, stdin);
      //
      //          JesusFreke suggests this instead- retry with successively
      //          smaller readsizes on systems that can't handle full
      //          POSIX-style massive block transfers.
      int readsize = data_window_size - 1;
      while (! feof (stdin) && i < data_window_size - 1)
	{
	  //i += fread (cdw->filetext + i, 1, readsize-1, stdin);
	  int rs;
	  rs = i + readsize < data_window_size - 1 ?
	    readsize : data_window_size - i - 1;
	  i+= fread (cdw->filetext + i, 1, rs, stdin);
	  if (feof (stdin))
	    {
	      break;
	    };
	  if (ferror (stdin))
	    {
	      if (errno == ENOMEM && readsize > 1) //  insufficient memory?
		{
		  readsize = readsize / 2;   //  try a smaller block
		  clearerr (stdin);
		}
	      else
		{
		  fprintf (stderr, "Error while trying to get startup input.  "
			   "This is usually pretty much hopeless, but "
			   "I'll try to keep running anyway.  ");
		  break;
		};
	    };
	};
    };

  //   data window is now preloaded (we hope), set the cdwo up.

  cdw->filetext[i] = '\000';
  cdw->nchars = i;
  cdw->hash = strnhash (cdw->filetext, cdw->nchars);
  cdw->mct = NULL;
  cdw->nstmts = -1;
  cdw->cstmt = -1;
  cdw->caller = NULL;

  // and put the initial data window suck-in contents into the vht
  //  with the special name :_dw:
  //
  //   GROT GROT GROT  will have to change this when we get rid of separate
  //   areas for the data window and the temporary area.  In particular, the
  //   "start" will no longer be zero.  Note to self: get rid of this comment
  //   when it gets fixed.  Second note to self - since most of the insert
  //   and delete action happens in :_dw:, for efficiency reasons perhaps
  //   we don't want to merge these areas.
  //
  {
    long dwname;
    long dwlen;
    tdw->filetext[tdw->nchars] = '\n';
    tdw->nchars++;
    dwlen = strlen (":_dw:");
    dwname = tdw->nchars;
    //strcat (tdw->filetext, ":_dw:");
    memmove (&tdw->filetext[dwname], ":_dw:", dwlen);
    tdw->nchars = tdw->nchars + dwlen;
    //    strcat (tdw->filetext, "\n");
    memmove (&tdw->filetext[tdw->nchars], "\n", strlen ("\n"));
    tdw->nchars++;
    crm_setvar ( NULL,
		 0,
		 tdw->filetext,
		 dwname,
		 dwlen,
		 cdw->filetext,
		 0,
		 cdw->nchars,
		 -1,
		 0);
  };
  //
  //    We also set up the :_iso: to hold the isolated variables.
  //    Note that we must specifically NOT use this var during reclamation
  //    or GCing the isolated var storage area.
  //
  //    HACK ALERT HACK ALERT - note that :_iso: starts out with a zero
  //    length and must be updated
  //
#define USE_COLON_ISO_COLON
#ifdef USE_COLON_ISO_COLON
  {
    long isoname;
    long isolen;
    isolen = strlen (":_iso:");
    isoname = tdw->nchars;
    //strcat (tdw->filetext, ":_dw:");
    memmove (&tdw->filetext[isoname], ":_iso:", isolen);
    tdw->nchars = tdw->nchars + isolen;
    //    strcat (tdw->filetext, "\n");
    memmove (&tdw->filetext[tdw->nchars], "\n", strlen ("\n"));
    tdw->nchars++;
    crm_setvar ( NULL,
		 0,
		 tdw->filetext,
		 isoname,
		 isolen,
		 tdw->filetext,
		 0,
		 0,
		 -1,
		 0);
  };
#endif	// USE_COLON_ISO_COLON
  //    Now we're here, we can actually run!
  //    set up to start at the 0'th statement (the start)
  csl->cstmt = 0;

  status = crm_invoke ();

  //     This is the *real* exit from the engine, so we do not override
  // the engine's exit status with an engine_exit_base value.
  exit ( (char) status);
 }
