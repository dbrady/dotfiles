(transient-mark-mode 1)
(column-number-mode t)

;; Do civilized backup names.  Added by dbrady 2003-03-07, taken from
;; http://emacswiki.wikiwikiweb.de/cgi-bin/wiki.pl?BackupDirectory
(setq
 backup-by-copying t         ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/saves"))        ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)          ; use versioned backups

(global-set-key "\M-g" 'goto-line)
(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)

;; ----------------------------------------------------------------------
;; Try for clean github style commits:
;; - First line should add warning highlight after 50 chars
;; - Entire document should wrap at 72 chars
;; - Lines should start with bullets (* or -)
;; - Lines that wrap should wrap with
;;   a hanging indent that does not
;;   include the bullet
(setq elisp-directory (expand-file-name "~/.elisp"))
(setq package-directory (concat elisp-directory "/packages"))
(setq load-path (cons package-directory load-path))
(require 'column-marker)
(column-marker-1 50)

