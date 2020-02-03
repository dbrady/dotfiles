;; Going forward, I want to try to not touch the prelude internals but rather
;; override/fix them in here, that way I can upgrade prelude without having to
;; remember what I changed and where (because I'm never ever going to remember
;; any of that ever).

;; Sadly, this does not go away. Somehow prelude's "ivy" module is grabbing this
;; AFTER loading my stuff. How very very rude.
;; (global-set-key "\C-s" 'isearch-forward)
;;
;; So instead of fixing it and forgetting it, I'll fix it and DOCUMENT it. I
;; went into ~/.emacs.d/modules/prelude-ivy.el and found this on line 50:
;; (global-set-key "\C-s" 'swiper)
;; I commented it out.
