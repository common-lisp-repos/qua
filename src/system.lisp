(in-package #:qua)

(defclass system ()
  ((dependencies
    :initarg :dependencies
    :type cons
    :accessor dependencies)
   (entities
    :initarg :entities
    :type hash-table
    :accessor entities))
  (:default-initargs
   :dependencies nil
   :entities (make-hash-table)))

(defmacro defsystem (name (&rest dependencies))
  `(defclass ,name (system)
     ((dependencies
       :initform ',dependencies
       :type cons
       :accessor dependencies))))

(defmethod clear-system ((system system))
  (setf (entities system) (make-hash-table)))

(defun system-add-entity (system entity-id components)
  "Add entity directly into system."
  (if (components-in-system-p components system)
      (setf (gethash entity-id (entities system)) 1)
      (warn "Entity ~a doesn't satisfy dependencies of system ~a!~%" entity-id system)))

(defun system-add-entities (system &rest entities)
  "Adds (entity-id components) into SYSTEM."
  (iter (for (e ec) in entities)
    (system-add-entity system e ec)))

(defun system-remove-entity (system entity-id)
  (remhash entity-id (entities system)))

(defun system-remove-entities (system &rest entities)
  (iter (for e in entities)
    (system-remove-entity system e)))
