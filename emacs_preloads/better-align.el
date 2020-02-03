;; better-align.el - Convenience methods around M-x align

;; align-columns
;; Aligns selected region on whitespace columns
;;
;; Example:
;;   describe "some context" do
;;     subject(:response_body) { JSON.parse(response.body) }
;;     let(:event) { response_body["event"] }
;;     let(:callback) { event["callback"] }
;;   end
;;
;; Selecting the three inner lines and running align-columns:
;;   describe "some context" do
;;     subject(:response_body) { JSON.parse(response.body) }
;;     let(:event)             { response_body["event"]    }
;;     let(:callback)          { event["callback"]         }
;;   end


;; ----------------------------------------------------------------------

;; TODO - Write me. Not quite sure how to do it. Currently, C-u C-x \ will
;; invoke align-regexp with full options. Change the initial regexp from
;; \(\s-*\) to \(\s-+\), then accept all the defaults and choose y for repeat
;; throughout line. This will align the selection but will also eliminate any
;; indent--it changes the initial indent to 1 character. What I want is to
;; automatically do this space-based align AND reindent the selection.

;; I have tried:

;; narrow-to-region - MIGHT work if I select and save off the first line's
;; indentation, then select all, do the align, then go to start, mark, go to
;; last line, start of line, forward one space, replace rectangle with
;; indentation.

;; save begin and end of selection - won't work because the length of the
;; selection changes. Could perhaps use narrow-to-region and get the change in
;; length, then wide and (mark-region old_begin (+ old_end diff)) etc.
