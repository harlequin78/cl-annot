(in-package :cl-user)

(defpackage cl-annot.core
  (:use :cl)
  (:nicknames :annot.core)
  (:export :annotation-real
           :annotation-arity
           :annotation-inline-p
           :annotation-form
           :annotation-form-p
           :annotation
           :defannotation))

(in-package :annot.core)

(defun annotation-real (annot)
  "Return the real annotation of ANNOT."
  (get annot 'annotation-real))

(defun (setf annotation-real) (real annot)
  (setf (get annot 'annotation-real) real))

(defun annotation-arity (annot)
  "Return the number of arguments of ANNOT."
  (or (get annot 'annotation-arity) 1))

(defun (setf annotation-arity) (arity annot)
  (setf (get annot 'annotation-arity) arity))

(defun annotation-inline-p (annot)
  "Return non-nil if ANNOT should be expanded on read-time."
  (get annot 'annotation-inline-p))

(defun (setf annotation-inline-p) (inline-p annot)
  (setf (get annot 'annotation-inline-p) inline-p))

(defun annotation-form (annot args)
  "Make an annotation-form with ANNOT and ARGS."
  `(annotation ,annot ,@args))

(defun annotation-form-p (form)
  "Return non-nil if FORM is an annotation-form."
  (and (consp form)
       (consp (cdr form))
       (eq (car form) 'annotation)))

(defmacro defannotation (name lambda-list attrs &body body)
  `(progn
     ,@(if (getf attrs :alias)
           `((setf (annotation-real ',(getf attrs :alias)) ',name)))
     ,@(if (getf attrs :arity)
           `((setf (annotation-arity ',name) ,(getf attrs :arity))))
     ,@(if (getf attrs :inline)
           `((setf (annotation-inline-p ',name) t)))
     (defmacro ,name ,lambda-list ,@body)))
