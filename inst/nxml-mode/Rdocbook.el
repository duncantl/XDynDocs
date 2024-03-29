(require 'cl)

; Tags:  invisible

; wrap up a node and send it to a special R evaluation function which can deal with 
; the nested r:output node. 
;
; this would also allow us to do a lot more XML processing in R, e.g.
;  for evaluating a section

; test if we are inside an r:.. node when evaluating content.

; get-node-content-region needs to adjust for CDATA.

; Add to ESS to insert command and output into document.
;  
; Use DCOM to do something similar with Word.

; [Done]Send code from a node to ESS


; Allow return-return i.e. two blank lines to expand to <para>\n</para>
;  For now just C-c C-p [Done]

; Allow output from R to be inserted into the <r:code> elements
;   update any existing <r:output> already there.


; Create our own keymap or add to nxml-mode-map.

; [Done] RNG support for the R extensions to docbook.
;    see
;

(defun foo (node cdata newline)
  (interactive)
  (let ((start (region-beginning))
        (end  (region-end)))
      (save-excursion
         (goto-char start)
         (insert (concat "<" node ">"))
         (if cdata (progn (insert "<![CDATA[") (if newline (insert "\n"))))        
         (goto-char (+ end (+ 3 (length node) (if cdata 9) (if newline 1))))
         (insert (concat (if cdata "]]>" "") (if newline "\n") "</" node ">"))
      ))
)


;
; FIXME: Make this smarter so that if a region is active then we surround that with the open and end block
;  Done. See the next function.
;(defun r-insert-node (node &optional cdata newline)
; "Put in node and move to the middle. Supports adding CDATA block and/or a new line in the middle, be it with or   without the CDATA"
;(interactive "*")
;(insert (concat "<" node ">"))
;(if cdata (progn (insert "<![CDATA[") (if newline (insert "\n\n"))  (insert "]]>")) (if newline (insert "\n\n")))
;(insert (concat "</" node ">"))
;(backward-sexp)
;(if newline (next-line) (if cdata (search-forward "<![CDATA[")  (forward-char (+ (length node) 2))))
;)


; We set newline and space-around to the value of cdata if they are not specified.
; See the Arg-List section of the Emacs Lisp manual. http://www.gnu.org/software/emacs/manual/html_node/cl/Argument-Lists.html
; Seems we can do it with initform values, but not working. Note the * after defun - !
; Can even create a variable that is set if a variable is set.

; defun* doesn't work on the Mac's basic emacs, i.e. /usr/bin/emacs.

(defun* r-insert-node (node &optional (cdata t) (newline cdata) (space-around cdata) (empty nil))
  "Put in node and move to the middle. Supports adding CDATA block and/or a new line in the middle, be it with or without the CDATA"
 (interactive "sEnter node name: \nP")
;   (if (not space-was-set) (setq space-around cdata))
     (if mark-active
       (progn 
             ; Do the end first. This ensures that the end point won't move!
          (goto-char (region-end))
	  (insert (concat "</" node ">"))
	  (if space-around (save-excursion (insert "\n"))) 
	  (backward-char (+ (length node) 3))
	  (if newline (insert "\n"))
	  (if cdata (insert "]]>"))

          (goto-char (region-beginning))
	  (if space-around (insert "\n"))
          (insert (concat "<" node ">"))
          (if cdata (progn 
                       (insert "<![CDATA[") 
                       (if newline (insert "\n")))
	            (if newline (insert   "\n")))
	  (forward-sexp)
          (goto-char (nxml-token-after)) ; move to just after the newly added </node>
       )

       (progn
        (if empty (insert (concat "<" node "/>"))
  	    (progn  (if space-around (insert "\n"))
                    (insert (concat "<" node ">"))
                    (if cdata (progn 
                       (insert "<![CDATA[") 
                       (if newline (insert "\n\n"))  
                       (insert "]]>")) 
                       (if newline (insert   "\n\n")))
	  (insert (concat "</" node ">"))
	  (if space-around (progn (insert "\n") (backward-char)))
	  (backward-sexp)
          (if newline (search-forward ">"))
	  (if newline (forward-char 1) ; (next-line -1)
                      (if cdata (search-forward "<![CDATA[")  
                                (forward-char (+ (length node) 2))))))
)))



; Given we are at a point, escape the contents of the enclosing node
; with a <![CDATA[ .... ]]>

; Hard to find the beginning and end of the node precisely because we have special
; characters.
; This is hardish
;
(defun surround-with-cdata ()
   ""
   (interactive "*")
   (let ((r (get-node-content-region)))
     (save-excursion
         (goto-char (nth 0 r))
         (insert "<![CDATA[")
         (goto-char (+ (nth 1 r) 9))
         (insert "]]>")))
)


;1117,  1148

; Return the start and end point as a list/vector.
; Now deals with CDATA and return only the inner content.
; Can't handle CDATA with text before or after outside of the CDATA, e.g.
; <r:code>
;  x = rnorm(10)
; <![CDATA[
;  x < 1 & x != 0
;  
;
(defun get-node-content-region ()
   "return a list containing the positions of the start and end of the current node.
    Starting within a node, this jumps to the start of that node, i.e. to the '<' in <r:code>.
    Then it figures out the end of the tag i.e. just after the '>' and then jumps to the end
    of the node, i.e. jst before the '<' in </r:code>"
   (interactive "*")

   (save-excursion
     (nxml-backward-up-element)
         ; this is the start of the content.
     (let ( (start (nxml-token-after))) ; 

       (progn
           (goto-char start)
           (if (looking-at "\n*<!\\[CDATA\\[")
             (progn 
                (search-forward "<![CDATA[")
                (setq start (point))
                (search-forward "]]>")
                (backward-char 3))
             (forward-sexp))
             (list start (point)))
       ))
)

(defun get-node-content-value ()
  ""
 (interactive)
 (let ((pos (get-node-content-region)))
   (progn (buffer-substring-no-properties (nth 0 pos) (nth 1 pos)))))

;
; Need to deal with <r:output>
; Ideally would like to have a function to do xmlValue(current-node)
; or that returns the start and end of each segment.

(defun rxml-eval-node-contents ()
    "evaluate the contents of the current XML node, e.g. r:code. 
This deals with a CDATA escape and extracts the contents from that."
    (interactive)
    (let ((pos (get-node-content-region)))

	
      ; we would prefer to work with positions and send the extents to ess.
     ; (ess-eval-region (nth 0 pos) (nth 1 pos) nil)
     ;  we could work with the string directly.
     ;  (ess-eval-linewise (discard-cdata (buffer-substring start (point))))
     ; but the positions seem better for now.
        (require 'ess-inf)
        (let ( (off (discard-cdata (buffer-substring-no-properties (nth 0 pos) (nth 1 pos)))))
           (ess-eval-region (+ (nth 0 pos) (nth 0 off)) (+ (nth 0 pos) (nth 1 off)) nil) )
     )
)

;; Doesn't work yet. Grabbing the output is messed up.
(defun rxml-eval-with-output ()
  (interactive)
  (let* ((rbuf (get-ess-buffer "R"))
         (r-original-end (save-excursion 
                           (set-buffer rbuf)
                       (insert "<start>") 
                           (point)))) 
      (rxml-eval-node-contents)
      (save-excursion 
	(set-buffer rbuf)
        (save-excursion
          (insert "</start>\n")
   	  (message "%s (%d %d)" 
		 (buffer-substring r-original-end (point-max)) r-original-end (point-max))))
     )
)

; (posix-string-match "<!\\[CDATA" My)
; tests.
;(setq My "<![CDATA[\nsummary(x)\nhist (x)\n]]>")
;(posix-string-match "<!\\[CDATA\\[" My)
;(posix-string-match "\\]\\]>" My)

; can't just use a regular expression and pull out the bit between the 
;   <![CDATA[(.*)]]>
; as we don't match across newlines.
; so this is not useful.
(defun discard-cdata (str)
  ""
  (interactive)
  (message "[discard-cdata]x%sx" str)
  (if (posix-string-match "\\<\\!\\[CDATA\\[\\(.\\)\\]\\]\\>" str)
      (progn (message "got a match %s") (match-string 1))
      str)
)


(defun discard-cdata (str)
  "return the offsets from the beginning for the content within a CDATA section or the entire string if no CDATA"
  (interactive)
;  (message "[discard-cdata]x%sx" str)
  (if (posix-string-match "<!\\[CDATA\\[" str)
      (list (+ 9 (match-beginning 0)) (- (posix-string-match "\\]\\]>" str) 1))    
      (list 0 (length str))
     )
)



(defun rxml-eval-node-with-output ()
 "This version takes the content of the current r:code/r:... node and 
  uses ess-eval-region() to run the code.  It uses its own filter to collect the output
  and copy it to the target buffer as well as make the result available as a string.
  This currently handles synchornization in a kludgy way by just waiting 3 seconds."
 (interactive)
 (let* ((proc (get-ess-process ess-current-process-name))
        (cmd (get-node-content-region))
        (start (marker-position (process-mark proc)))
        old-filter value ( ctr 0))

 (unwind-protect
   (progn 
      (setq oldfilter (process-filter proc))
      (set-process-filter proc #'(lambda (proc output) 
                                    (setq value (concat value output))
                                    (ordinary-insertion-filter proc output)))
      (ess-eval-region (nth 0 cmd) (nth 1 cmd)  nil)
(sleep-for 3))
   (set-process-filter proc old-filter))
 (ess-replace-in-string (ess-replace-in-string value "> >" ">") "\n> " "")
))


(defun rxml-eval-node-insert-output ()
  "evaluate the code in the current XML node and insert the results within an <r:output>...</r:output> element"
 (interactive)
 (insert-r-output (rxml-eval-node-with-output))
)

(defun insert-r-output (str)
  "takes the output from R and inserts it within an <r:output>...</r:output> element, replacing an existing r:output element"
  (interactive)
  (save-excursion
     (forward-sexp)
         ; check if the code is within a CDATA and we jumped to the end of this.
     (if (looking-at "]]>") (forward-char 3))
         ; check if we already have an r:output node here and if so, replace it.
     (if (looking-at "<r:output") 
         (progn 
            (let ((cur (point)))
                (search-forward "</r:output>")
                (kill-region cur (goto-char (point)))
                )))
         (progn 
            (insert (format "<r:output><![CDATA[%s\n]]></r:output>" str)))
  )
)


(defun r-insert-rexpr (evalFalse)
  "insert r:expr node, optionally with eval='false'"
  (interactive  (list (or current-prefix-arg nil)))
  (r-insert-node "r:expr" nil) 
  (if evalFalse 
      (progn ; (r-insert-attribute-value "eval" "false")
    	(backward-sexp)
	(search-forward "<r:expr")
        (insert-attribute "eval" "false") 
	(search-forward "</r:expr>")
	)))

(defun r-insert-rexpr1 (evalFalse)
  "insert r:expr node, optionally with eval='false'"
  (interactive  (list (or current-prefix-arg nil)))
  (let ((p1 (region-beginning))
	(p2 (region-end))
	(has-region (use-region-p)))
    
    (r-insert-node "r:expr" nil) 
    (if evalFalse 
	(progn ; (r-insert-attribute-value "eval" "false")
	  (if (eq p1 p2)
	      (r-insert-attribute-value "eval" "false")
    	    (progn (backward-sexp)
		   (search-forward "<r:expr")
		   (insert-attribute "eval" "false") 
		   (search-forward "</r:expr>")
		   ))))))



(defun r-insert-class (s3) 
   "" 
   (interactive (list (or current-prefix-arg nil))) 
   (r-insert-node (if s3 "r:s3class" "r:class") nil))





(defun rh-insert-example ()
  ""
  (interactive)
  (r-insert-node "rh:example")
  (insert "\n")
  (r-insert-node "rh:title")
  (insert "\n")
  (r-insert-node "rh:description")
  (insert "\n")
  (r-insert-node "r:code")
)

(defun insert-formal-para ()
  (insert "<formalpara>\n<title></title>\n<para>\n\n</para>\n</formalpara>\n")
  (previous-line)
)

(defun insert-itemized-list ()
  (insert "<itemizedlist>\n<listitem><para>\n\n</para></listitem>\n</itemizedlist>\n")
  (previous-line)
)

; look to see if the string from here to back up is 
;  \n


(defun use-rcode-mode-p ()
  "Determine whether we are in an r:code, r:function or r:plot node."
  (interactive) 
  (condition-case nil
    (save-excursion
       (nxml-backward-up-element)
  ;     (message "switch to rcode? %S" (or (or (looking-at "<r:code") (looking-at "<r:function") ) (looking-at "<r:plot")))
       (or (or (looking-at "<r:code") (looking-at "<r:function") ) (looking-at "<r:plot"))
    )
    (error nil)
  )
)

(defun rnxml-switch-mode ()
    ""
    (interactive "*")
    (let ((v (use-rcode-mode-p)))
      (message "rcode? %S" v)
      (if v
        (ess-mode)
        (nxml-mode))
    )
)



  


(defvar r-default-nxml-file
   "~/DefaultXML.xml"
   "*name of the file which will be inserted when an empty XML buffer is created and nxml mode is loaded"
)

(setq r-default-nxml-file "~/DefaultXML.xml")

(defun r-insert-func (arg)
   "" 
   (interactive "P") 
   (r-insert-node "r:func" nil) 
   (if arg (r-insert-attribute-value "pkg" "")))

(defun r-nxml-keys-map (map)
  "register key bindings for R-related nodes (i.e. r:...) in XML documents"
  (interactive "*")
  (define-key map "\C-ix" #'(lambda () "" (interactive "*") (insert "<xi:include href=\"\"/>")))  
  (define-key map "\C-qr" #'(lambda () "" (interactive "*") (insert "<r/>")))
  (define-key map "\C-qc" 'r-insert-class)
  (define-key map "\C-qa" #'(lambda () "" (interactive "*") (r-insert-node "r:arg" nil)))
  (define-key map "\C-qx" 'r-insert-rexpr)
  (define-key map "\C-qv" #'(lambda () "" (interactive "*") (r-insert-node "r:var" nil)))
  (define-key map "\C-qm" #'(lambda () "" (interactive "*") (r-insert-node "r:el" nil)))
  (define-key map "\C-qp" #'(lambda (omg) "" (interactive "P") (r-insert-node (if omg "omg:pkg" "r:pkg") nil)))
  (define-key map "\C-qf" 'r-insert-func)
  (define-key map "\C-c\C-ao" #'(lambda () "" (interactive "*") (r-insert-node "ol" nil t)))
  (define-key map "\C-c\C-au" #'(lambda () "" (interactive "*") (r-insert-node "ul" nil t)))
  (define-key map "\C-c\C-al" #'(lambda () "" (interactive "*") (r-insert-node "li" nil)))
  (define-key map "\C-c\C-a\C-a" #'(lambda () "" (interactive "*") (insert "<a href=\"\"></a>") (backward-char 6)))
  (define-key map "\C-qk" #'(lambda () "" (interactive "*") (r-insert-node "r:keyword" nil)))
  (define-key map "\C-qs" #'(lambda () "" (interactive "*") (r-insert-node "r:s3method" nil)))
  (define-key map "\C-q\C-o" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:output" (not cdata) t nil)))
  (define-key map "\C-q\C-e" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:error" (not cdata) t nil)))
  (define-key map "\C-q\C-w" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:warning" (not cdata) t nil)))

  (define-key map "\C-q\C-c" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:code" cdata t nil))) ; was t t
  (define-key map "\C-x\C-q\C-c" #'(lambda () "" (interactive "*") (r-insert-node "r:function" t t nil) (goto-char (nxml-token-after)) (r-insert-node "r:output" t t)))
  (define-key map "\C-x\C-q\C-f" #'(lambda () "" (interactive "*") (r-insert-node "r:function" t t nil) (r-insert-node "r:output" t t)))
  (define-key map "\C-q\C-q" #'(lambda () "" (interactive "*") (r-insert-node "sql:code" nil t nil) ))
  (define-key map "\C-x\C-q\C-e" #'(lambda () "" (interactive "*") (r-insert-node "sql:expr" nil nil nil) ))
  (define-key map "\C-x\C-q\C-x" #'(lambda () "" (interactive "*") (r-insert-node "sql:expr" nil nil nil) ))
  (define-key map "\C-x\C-q\C-q" #'(lambda () "" (interactive "*") (r-insert-node "sql:code" nil t nil) ))
  (define-key map "\C-x\C-q\C-o" #'(lambda () "" (interactive "*") (r-insert-node "sql:output" nil t nil) ))
  (define-key map "\C-x\C-q\C-t" #'(lambda () "" (interactive "*") (r-insert-node "sql:table" nil nil nil) ))
  (define-key map "\C-x\C-q\C-f" #'(lambda () "" (interactive "*") (r-insert-node "sql:field" nil nil nil) ))
  (define-key map "\C-c\C-r" #'(lambda () "" (interactive "*") (insert "<xref linkend=\"\"/>") (backward-char 3)))

  (define-key map "\C-ld" #'(lambda () "" (interactive "*") (r-insert-node "dir" nil)))  
  (define-key map "\C-lf" #'(lambda () "" (interactive "*") (r-insert-node "file" nil)))
  (define-key map "\C-lx" #'(lambda () "" (interactive "*") (r-insert-node "ext" nil)))         
  (define-key map "\C-lg" #'(lambda () "" (interactive "*") (r-insert-node "sh:flag" nil)))  
  (define-key map "\C-le" #'(lambda () "" (interactive "*") (r-insert-node "sh:exec" nil)))
  (define-key map "\C-lc" #'(lambda () "" (interactive "*") (r-insert-node "sh:cmd" nil)))

  (define-key map "\C-jv" #'(lambda () "" (interactive "*") (r-insert-node "js:var" nil)))
  (define-key map "\C-jf" #'(lambda () "" (interactive "*") (r-insert-node "js:func" nil)))  
  (define-key map "\C-j\C-c" #'(lambda (cdata) "" (interactive "P") (r-insert-node "js:code" cdata t nil)))    
				;
;  Okay to here.
  (define-key map "\C-ll" #'(lambda () "" (interactive "*") (r-insert-node "llvm" nil)))  
  (define-key map  "\C-lo" #'(lambda() "" (interactive "*") (insert "<ol>\n<li></li>\n</ol>")  ))
  (define-key map  "\C-lu" #'(lambda() "" (interactive "*") (insert "<ul>\n<li></li>\n</ul>")  ))  

  

  ; r:function  (definition)
;  (define-key map  "\C-x\C-r\C-f" #'(lambda () "" (interactive "*") (r-insert-node "r:function" t t)))
  (define-key map  "\C-q\C-f" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:function" (not cdata) t nil)))
  ; r:test
  (define-key map  "\C-q\C-t" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:test" (not cdata) t t)))
 ; r:plot
  (define-key map  "\C-q\C-d" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:plot" (not cdata) t nil)))
  ; C-q C-p is overridden by ESS.
  (define-key map  "\C-q\C-p" #'(lambda (cdata) "" (interactive "P") (r-insert-node "r:plot" (not cdata) t nil)))

   ; make smarter to know if we need the /ignore on a new line.
  (define-key map  "\C-q\C-i" #'(lambda () "" (interactive "*") (r-insert-node "ignore" nil t t)))
; (insert "<ignore>") (nxml-forward-element) (insert "\n</ignore>")

  (define-key map "\C-q@" #'(lambda () "" (interactive "*") (r-insert-node "r:attr" nil)))
  
   ; <para>\n</para>
  (define-key map  "\C-q\C-p" #'(lambda () "" (interactive "*") (r-insert-node "para" nil t)))
  (define-key map  "\C-q\C-return" #'(lambda () "" (interactive "*") (r-insert-node "para" nil t)))
  (define-key map  "\C-c\C-p" #'(lambda () ""  
                               (interactive "*") 
                               (insert "\n") 
                               (r-insert-node "para" nil t) 
                               (save-excursion  
                                  (search-forward "</para>")
                                  (insert "\n"))))

  (define-key map  "\C-q\C-n" 'rxml-eval-node-contents)
  (define-key map  "\C-q\C-p" 'rxml-eval-node-insert-output)

;  (define-key map  "\C-c\C-l\C-l" #'(lambda () ""  (interactive "*") (insert-itemized-list)))
;  (define-key map  "\C-c\C-l\C-i" #'(lambda () ""  (interactive "*") (r-insert-node "li")))

;; okay to here

  (define-key map  "\C-c\C-s\C-s" #'(lambda () ""  
                                   (interactive "*") 
                                   (r-insert-node "section" nil t)
                                   (r-insert-node "title" nil nil)
                                   (nxml-up-element)
                                   (insert "\n\n")
                                   (r-insert-node "para" nil t)
                                 ))

  
  (define-key map  "\C-l\C-l" #'(lambda () ""  (interactive "*") (r-insert-node "literal" nil)))
  
  (define-key map  "\C-qo" #'(lambda () ""  (interactive "*") (r-insert-node "r:op" nil)))
  (define-key map  "\C-qt" #'(lambda () ""  (interactive "*") (insert "<r:true/>")))
  (define-key map  "\C-qT" #'(lambda () ""  (interactive "*") (insert "<r:true/>")))
  (define-key map  "\C-qF" #'(lambda (arg) ""  (interactive "P") (insert "<r:false/>")))

; <xml:*> elements used for talking about XML.
  (define-key map  "\C-x\C-x" #'(lambda () ""  (interactive "*") (r-insert-node "xml:tag" nil)))
  (define-key map  "\C-x\C-a" #'(lambda () ""  (interactive "*") (r-insert-node "xml:attr" nil)))
  (define-key map  "\C-x\C-n" #'(lambda () ""  (interactive "*") (r-insert-node "xml:ns" nil)))
  (define-key map  "\C-x\C-e" #'(lambda () ""  (interactive "*") (r-insert-node "xml:expr" nil)))

  (define-key map  "\C-ql" #'(lambda () ""  (interactive "*")
;;;XXX if we have a selection, use this as the url attribute value
                     (if mark-active
                       (progn
                         (save-excursion)
                         (goto-char (region-end))
                         (insert "\"/>")
                         (goto-char (region-beginning))
                         (insert "<ulink url=\"")
                       )
                       (progn
                                                 (r-insert-node "ulink" nil nil nil t) 
                                                 (backward-char 2)
                                                 (insert " url=\"\"")
                                                 (forward-char 2)
;                                                (r-insert-attribute-value "url" "")
                                                 (backward-char 3)
						 ))))


  (define-key map  "\C-ck" #'(lambda () ""  (interactive "*") (r-insert-node "cpp:class" nil)))
  (define-key map  "\C-cm" #'(lambda () ""  (interactive "*") (r-insert-node "cpp:method" nil)))
  (define-key map  "\C-ce" #'(lambda () ""  (interactive "*") (r-insert-node "c:expr" nil)))        
  (define-key map  "\C-ct" #'(lambda () ""  (interactive "*") (r-insert-node "c:type" nil)))
  (define-key map  "\C-ca" #'(lambda () ""  (interactive "*") (r-insert-node "c:arg" nil)))          
  (define-key map  "\C-cv" #'(lambda () ""  (interactive "*") (r-insert-node "c:var" nil)))  
  (define-key map  "\C-cf" #'(lambda () ""  (interactive "*") (r-insert-node "c:func" nil)))
  (define-key map  "\C-cw" #'(lambda () ""  (interactive "*") (r-insert-node "c:keyword" nil)))
  (define-key map  "\C-co" #'(lambda () ""  (interactive "*") (r-insert-node "c:op" nil)))
  (define-key map  "\C-cs" #'(lambda () ""  (interactive "*") (r-insert-node "c:struct" nil)))  
  (define-key map  "\C-ch" #'(lambda () ""  (interactive "*") (r-insert-node "c:header" nil)))
  (define-key map  "\C-c\C-c" #'(lambda (omg) ""  (interactive "P") (r-insert-node (if omg "c:routine" "c:code") t t nil))) 

; Put in a <programlisting> but add white space to avoid reformatting messing it up.
  (define-key map  "\C-x\C-p" #'(lambda () ""  (interactive "*") (insert "\n") (r-insert-node "programlisting" t t nil) (save-excursion (forward-sexp) (goto-char (nxml-token-after))  (goto-char (nxml-token-after))  (insert "\n\n"))))
  (define-key map  "\C-x\C-p" #'(lambda () ""  (interactive "*")  (r-insert-node "programlisting" t t nil)
 ))

;;XXX Fails.
;  (define-key map  "\C-q\C-l" #'(lambda () ""  (interactive "*")  (r-insert-node "listitem" nil nil nil) (r-insert-node "para" nil t nil)))

  (define-key map  "\C-x\C-l" #'(lambda () ""  (interactive "*")  (r-insert-node "listitem" nil nil nil) (r-insert-node "para" nil t nil)))

  (define-key map  "\C-q\C-h" #'(lambda () ""  (interactive "*")  (insert "<html/>")))
;  (define-key map  "\C-q\C-r" #'(lambda () ""  (interactive "*")  (insert "<R/>")))
;  (define-key map  "\C-x\C-l" #'(lambda () ""  (interactive "*")  (insert "<latex/>")))
					;  (define-key map  "\C-q\C-d" #'(lambda () ""  (interactive "*")  (insert "<docbook/>")))
  
  (define-key map  "\C-q\C-r" #'(lambda () ""  (interactive "*")  (insert "<r/>")))

; Not quite correct!
  (define-key map  "\C-x\C-j" #'(lambda () ""  (interactive "*") (r-insert-node "note" nil t) (r-insert-node "para" nil t nil)))

  (define-key map  "\C-qb" 'insert-bib)

  (define-key map  "\C-qn" 'r-add-namespace-def)
  (define-key map  "\C-qi" 'r-insert-id)

; insert-list gives an error after the <ol>. Need C-u number before C-qC-l
  (define-key map  "\C-q\C-l" 'insert-list)

    ; for Todo.xml files. Put separately.
    ; XXX get good key bindings for these. 
  (define-key map  "\C-q\C-s" 'insert-date-stamp)

  (define-key map "\C-qe" #'(lambda () "" (interactive "*") (r-insert-node "r:slot" nil)))

  (define-key map "\C-q." #'(lambda () "" (interactive "*") (r-insert-node "r:dots" nil nil nil t)))
  (define-key map "\C-qu" #'(lambda () "" (interactive "*") (r-insert-node "r:null" nil nil nil t)))  

  
  (define-key map "\C-l\C-f" #'(lambda (cdata) "" (interactive "P") (r-insert-node "sh:code" cdata t nil)))  
  (define-key map "\C-l\C-c" #'(lambda (cdata) "" (interactive "P") (r-insert-node "sh:code" cdata t nil)))
  (define-key map "\C-lv" #'(lambda () "" (interactive "*") (r-insert-node "sh:env" nil)))
  (define-key map "\C-la" #'(lambda () "" (interactive "*") (r-insert-node "sh:arg" nil)))
  (define-key map "\C-xt" #'(lambda () "" (interactive "*") (r-insert-node "xml:tag" nil)))
  (define-key map "\C-xa" #'(lambda () "" (interactive "*") (r-insert-node "xml:attr" nil)))

  (define-key map "\C-l\C-o" #'(lambda (cdata) "" (interactive "P") (r-insert-node "sh:output" (not cdata) t nil)))


;;;; Can't use C-a
   (define-key map "\C-i\C-c" #'(lambda (cdata) "" (interactive "P") (r-insert-node "py:code" cdata t t)))

   (define-key map "\C-ic" #'(lambda () "" (interactive "*") (r-insert-node "ir:code" nil)))


   (define-key map "\C-id" #'(lambda () "" (interactive "*") (insert "<emdash/>")))

 ; (define-key map "\C-g\C-g" #'(lambda () "" (interactive) (insert "<glossentry><glossterm></glossterm>\n<glossdef><para>\n\n</para></glossdef>\n</glossentry>")))


   ; bound to ignore
;  (define-key map  "\C-q\C-i" #'(lambda (arg) "" (interactive "P") (r-insert-node "item" nil t)))

;  (define-key map  "\C-r\C-r" 'isearch-backward)
)

(defvar r-nxml-mode-init nil)


;(setq ispell-skip-region-alist (append r-ispell-html-skip-alists ispell-skip-region-alist))
;(setq ispell-html-skip-alists (append r-ispell-html-skip-alists ispell-html-skip-alists))

(add-hook 'nxml-mode-hook
	  #'(lambda ()
            (if (not r-nxml-mode-init) (progn (r-nxml-keys-map nxml-mode-map) (setq r-nxml-mode-init t)))
;	    (flyspell-xml-lang-setup)
;	    (add-hook 'post-command-hook 'rnxml-switch-mode t)
	    (when (and (and (file-exists-p r-default-nxml-file) 
                            (string-equal "Rdb" (file-name-extension (buffer-file-name))))
                       (not (and (buffer-file-name)
			         (file-exists-p (buffer-file-name)))))
 	      (insert-file (expand-file-name r-default-nxml-file)))
	    ;; if this is an xsl file, add the xsl:stylesheet node.
;	    (when (and (string-equal "xsl" (file-name-extension (buffer-file-name)))
;                      (not (and (buffer-file-name)
;			         (file-exists-p (buffer-file-name)))))
;	      (insert  "<xsl:stylesheet\n\t xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"\n\tversion='1.0'>\n\n\n\<xsl:stylesheet>\n")
;             (previous-line)
;             (previous-line)
;           )
          )
	  t)  ; t means append



;(defvar r-nxml-minor-mode-map
;  (let ((map (make-sparse-keymap)))
;    map)
;  "keymap for R minor mode within nxml"
;)


; (define-key r-nxml-minor-mode-map "\C-r\C-c" 'r-code)
; (define-key r-nxml-minor-mode-map "\C-r\C-e" 'r-expr)
; (define-key r-nxml-minor-mode-map "\C-r\C-v" 'r-var)


;(if (not (assq 'r-nxml-mode minor-mode-alist))
;   (setq minor-mode-alist (append minor-mode-alist
;                                   (list '(r-nxml-mode " R-nxml")))))

;(if (not (assq 'nxml-mode minor-mode-map-alist))
;    (setq minor-mode-map-alist
;          (cons (cons 'noweb-mode r-nxml-minor-mode-map)
;                minor-mode-map-alist))
;)


(defvar rxml-namespaces (make-hash-table)
   "")

(puthash (intern "css") "http://www.w3.org/Style/CSS/" rxml-namespaces)
(puthash (intern "r") "http://www.r-project.org" rxml-namespaces)
(puthash (intern "http") "http://www.w3.org/Protocols" rxml-namespaces)
(puthash (intern "db") "http://docbook.org/ns/docbook" rxml-namespaces)
(puthash (intern "sh") "http://www.shell.org" rxml-namespaces)
(puthash (intern "sch") "http://www.w3.org/2001/XMLSchema" rxml-namespaces)
(puthash (intern "omg") "http://www.omegahat.org" rxml-namespaces)
(puthash (intern "curl") "http://curl.haxx.se" rxml-namespaces)
(puthash (intern "make") "http://www.make.org" rxml-namespaces)
(puthash (intern "mk") "http://www.make.org" rxml-namespaces)
(puthash (intern "env") "http://www.shell-environments.org" rxml-namespaces)
(puthash (intern "xp") "http://www.w3.org/TR/xpath" rxml-namespaces)
(puthash (intern "xi") "http://www.w3.org/2003/XInclude" rxml-namespaces)
(puthash (intern "xsl") "http://www.w3.org/1999/XSL/Transform" rxml-namespaces)
(puthash (intern "xml") "http://www.w3.org/XML/1998/namespace" rxml-namespaces)
(puthash (intern "bioc") "http://www.bioconductor.org" rxml-namespaces)
(puthash (intern "java") "http://www.java.com" rxml-namespaces)
(puthash (intern "dcom") "http://www.microsoft.com/DCOM" rxml-namespaces)
(puthash (intern "c") "http://www.C.org" rxml-namespaces)
(puthash (intern "cpp") "http://www.C++.org" rxml-namespaces)
(puthash (intern "s") "http://cm.bell-labs.com/stat/S4" rxml-namespaces)
(puthash (intern "rx") "http://www.regex.org" rxml-namespaces)
(puthash (intern "c") "http://www.C.org" rxml-namespaces)
(puthash (intern "statdocs") "http://www.statdocs.org" rxml-namespaces)
(puthash (intern "gtk") "http://www.gtk.org" rxml-namespaces)
(puthash (intern "python") "http://www.python.org" rxml-namespaces)
(puthash (intern "py") "http://www.python.org" rxml-namespaces)
(puthash (intern "xmlns:perl") "http://www.perl.org" rxml-namespaces)
(puthash (intern "rwx") "http://www.omegahat.org/RwxWidgets" rxml-namespaces)
(puthash (intern "ecma") "http://www.ecma-international.org/publications/standards/Ecma-262.htm" rxml-namespaces)
(puthash (intern "js") "http://www.ecma-international.org/publications/standards/Ecma-262.htm" rxml-namespaces)
(puthash (intern "bib") "http://www.bibliography.org" rxml-namespaces)
(puthash (intern "mtlb") "http://www.mathworks.com" rxml-namespaces)
(puthash (intern "oct") "http://www.octave.org" rxml-namespaces)
(puthash (intern "mtlb") "http://www.mathworks.com" rxml-namespaces)
(puthash (intern "m") "http://www.mathworks.com" rxml-namespaces)
(puthash (intern "fo") "http://www.w3.org/1999/XSL/Format" rxml-namespaces)
(puthash (intern "ltx") "http://www.latex.org" rxml-namespaces)
(puthash (intern "mml") "http://www.w3.org/1998/Math/MathML" rxml-namespaces)
(puthash (intern "html") "http://www.w3.org/TR/html401" rxml-namespaces)
(puthash (intern "sql") "http://www.sql.org" rxml-namespaces)
(puthash (intern "ir") "http://llvm.org/ir" rxml-namespaces)
(puthash (intern "llvm") "http://llvm.org" rxml-namespaces)
(puthash (intern "lldb") "http://llvm.org/lldb" rxml-namespaces)
(puthash (intern "gh") "http://github.com" rxml-namespaces)
(puthash (intern "as") "http://www.assemblycode.org" rxml-namespaces)
(puthash (intern "wasm") "http://webassembly.org" rxml-namespaces)
(puthash (intern "cpre") "http://www.preprocessor.org" rxml-namespaces)


(defun r-nxml-insert-at-namespace (prefix val)
  ""
    ; adds a new line no matter what if there is no <?xml version..?>
  (if (looking-at "<") (progn (search-forward ">") (backward-char)))
  (if (looking-at ">") (insert "\n\t "))
  (insert "xmlns:" prefix "=\"" val "\"")
  t
)

(defun r-nxml-insert-namespace (prefix val)
  ""
  (save-excursion
    (beginning-of-buffer)
    (if (looking-at "<\\?")
	(progn (forward-sexp)
	       (goto-char (nxml-token-after))
	       (backward-char)))
    (r-nxml-insert-at-namespace prefix val))
)

(defun r-add-namespace-def (prefix)
  (interactive "sEnter namespace prefix: ")
  (let ((val (gethash (intern prefix) rxml-namespaces nil)))
    (if val (r-nxml-insert-namespace prefix val)
            (message (concat "no XML namespace registered for " prefix))))
)

(defun r-insert-id (val)
   "insert an id=val attribute in the current node"
  (interactive "sEnter value for node id: ")
  (r-insert-attribute-value "id" val)
)

(defun r-insert-attribute-value (name val)
   "insert an name=val attribute in the current node"
  (interactive "sEnter value for node id: ")
  (save-excursion
     (nxml-backward-up-element)
     (search-forward ">")
     (backward-char)
     (insert-attribute name val))
)

(defun insert-attribute (name val)
  "insert a name='val' attribute at the current location, with a preceeding space. 
   The caller must have moved to the appropriate spot."
  (insert " " name "=\"" val "\"")
)


;(defvar   xxx-ispell-html-skip-alists ())
(setq r-ispell-html-skip-alists
  (append 
     '(
	("<r:code" . "</r:code>")
	("<r:func>" . "</r:func>")
	("<r:class>" . "</r:class>")
	("<r:slot>" . "</r:slot>")
	("<r:expr>" . "</r:expr>")
	("<r:function" . "</r:function>")
	("<r:commands" . "</r:commands>")
	("<r:output" . "</r:output>")
	("<r:var>" . "</r:var>")
	("<r:arg>" . "</r:arg>")
	("<r:pkg>" . "</r:pkg>")
	("<r:plot>" . "</r:plot>")
	("<.*:code" . "</.*:code>")
	("<omg:pkg>" . "</omg:pkg>")
	("<sh:code" . "</sh:code>")
	("<sh:expr>" . "</sh:expr>")
	("<sh:exec>" . "</sh:exec>")
	("<ignore>" . "</ignore>")
	("<xml:tag>" . "</xml:tag>")
	("<!-->" . "-->")
	("^```" . "^```")	
	("<!\\[CDATA\\[" . "\\]\\]\\>")
   )))

;(add-to-list 'ispell-skip-region-alist '("^<r:func" . "^</r:func>"))

(setq ispell-skip-region-alist r-ispell-html-skip-alists)

(defvar current-date-format "%a %b %d %Y"
  "Format of date to insert with `insert-date-stamp' func")

; (setq current-date-format "%a %b %d %Y")

(defun insert-date-stamp()
  "insert the current dateinto current buffer."
       (interactive)
       (insert (concat "<date>" (format-time-string current-date-format (current-time)) "</date>"))
       (insert "\n")
       )


(defun* insert-list (&optional (num 1) (type "ol") (el "li") )
 "insert <ol><li></li></ol>"
 (interactive "p")   ; with p rather than P, the C-u number is optional.
 (save-excursion
  (insert (concat "<" type ">\n"))
  (setq ctr 0)
  (while (< ctr num)
       (insert (concat "<" el ">" "</" el ">\n")) 
       (setq ctr (+ ctr 1)))
  (insert (concat "</" type ">\n")))
  (forward-char (+ (length type) (length el) 5))
)

(add-to-list 'auto-mode-alist '("\\.Rdb$" . nxml-mode))


(defun insert-bib (id)
   (interactive "sEnter bibliog id: ")
   (insert (concat "<citation><biblioref linkend='" 
                 (if (and (> (length id) 3)  (string-equal (substring id 1 4) "bib:")) id (concat "bib:" id)) 
               "'/></citation>"))
)

(defun insert-footnote (id)
   (interactive)
   (insert "<footnote><para> </para></footnote>"))
           


(defun insert-figure ()
  (interactive "")
   (insert "<figure id='fig:'>\n<title></title>\n<graphic fileref='' format=''/>\n<caption><para>\n</para>\n</caption>\n</figure>")
)

(defun insert-author()
   (interactive)
   (insert "<author><firstname></firstname><surname></surname></author>"))


(setq nxml-child-indent 0)

(provide 'Rdocbook)





