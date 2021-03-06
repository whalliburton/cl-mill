(in-package :gcode)

(defun minicommand-panels ()
  (let ((*frontplate-elements* nil))
    (let ((normal-panels
					 (loop for f in '("minicommand.lisp" "minicommand-ioboard.lisp")
							for filename = (format nil "/Users/manuel/siff-svn/ruinwesen/eagle/midicommand/~A" f)
							collect (calculate-panel-file filename))))

      (push `(with-tool (*pcb-tool*)
							 (goto-abs :x 19.5 :y 47)
							 (rectangle-inline 71 26 :depth 3.8)
							 (goto-abs :x -2 :y -2)
							 (rectangle-outline 114 92 :depth 3.8))
						*frontplate-elements*)
      (setf *frontplate-elements* (nreverse *frontplate-elements*))

      (append normal-panels
							(list (calculate-panel-code *frontplate-elements* :passname "frontplate"))))))



(defun test-file (&key (x 0) (y 0))
  (let ((*frontplate-elements* nil))
    (with-program ("file-tool")
      (with-tool (*pcb-tool*)

				(let* ((panels (minicommand-panels))
							 (orders (order-panels panels '((1 2 3)) 10)))
	  
					(with-transform ((translation-matrix x y))
						(loop for order in orders
							 for x = (second order)
							 for y = (third order)
							 for panel = (first order)
							 do (with-named-pass ("drill-fix")
										(with-tool (*pcb-tool*)
											(panel-drills x y panel)))
							 (schedule-panel panel x y)))))
      (optimize-pass "drills"))))

(defun test-minicommand (&key (x 2) (y 2))
  (with-program ("file-tool")
    (with-tool ((make-instance 'tool :diameter 2 :depth 4 :number 6 :feed-xy 600 :feed-z 240))
      (with-transform ((translation-matrix 0 0))
				(with-transform ((translation-matrix 90 0))
					(with-transform ((rotation-matrix -90))
						(with-transform ((translation-matrix 5 0.5))
	      
							(load-file "/Users/manuel/siff-svn/ruinwesen/eagle/midicommand/minicommand-ioboard.lisp"))))
	
				#+nil(with-named-pass ("frontplate")
							 (goto-abs :x 0 :y 0)
							 (rectangle-inline 95 120 :depth 4)))


	    )))

(defun cpu-pcb-drills ()
  (with-named-pass ("drills")
    (with-tool (*mdf-tool-2mm*)
			(with-transform ((translation-matrix 2.8 -0.75))
				(with-transform ((translation-matrix 90 0))
					(with-transform ((rotation-matrix -90))
						(with-transform ((translation-matrix 5 3))
							(drill :x 12.000000 :y 4.000000 :diameter 3.000000 :depth 8)
							(drill :x 97.000000 :y 4.000000 :diameter 3.000000 :depth 8)
							(drill :x 104.000000 :y 74.000000 :diameter 3.000000 :depth 8)
							(drill :x 6.000000 :y 74.000000 :diameter 3.000000 :depth 8))))))))

(defun minicommand-fix ()
  (with-named-pass ("power-fix")
    (with-tool (*pcb-gravier-tool*)
      (with-transform ((translation-matrix 2.8 -0.75))
				(with-transform ((translation-matrix 90 0))
					(with-transform ((rotation-matrix -90))
						(with-transform ((translation-matrix 5 3))
							;;	      #+nil
							(goto-abs :x 87.4 :y 78.4 :z *fly-height*)
							;;	      #+nil
							(with-tool-down (0.2)
								(mill-abs :x 87.4 :y 78.4)
								(mill-abs :x 83.4 :y 74.0))

							(goto-abs :x 86.2 :y 59.2 :z *fly-height*)
							(with-tool-down (0.2)
								(mill-abs :x 86.2 :y 56.6))

							;;	      #+nil
							(goto-abs :x 108.3 :y 46.2)
							;;	      #+nil
							(with-tool-down (0.2)
								(mill-abs :x 109.3 :y 46.2))

							;;	      #+nil
							(goto-abs :x 28.8 :y 27.6)
							;;	      #+nil
							(with-tool-down (0.2)
								(mill-abs :x 28.8 :y 16.8)
								(mill-abs :x 34.7 :y 16.8)
								(mill-abs :x 34.7 :y 27.6)
								(mill-abs :x 28.8 :y 27.6))

							)))))))


(defun minicommand-fix-bottom ()
  (let ((*fly-height* 10))
    (with-named-pass ("power-fix")
      (with-tool (*pcb-gravier-tool*)
				(with-transform ((mirror-matrix (2dp 0 1)))
					(with-transform ((translation-matrix -90 90))
						(with-transform ((translation-matrix 2.8 23.5))
							(with-transform ((rotation-matrix 90))
								(with-transform ((translation-matrix 5 3))
									#+nil
									(goto-abs :x 87.4 :y 78.4 :z *fly-height*)
									#+nil
									(with-tool-down (0.2)
										(mill-abs :x 87.4 :y 78.4)
										(mill-abs :x 83.4 :y 74.0))

									(let ((depth 0.6))
										(goto-abs :x 105.8 :y 68.4)
										(with-tool-down (depth)
											(mill-abs :x 97.2 :y 68.4)
											(mill-abs :x 97.2 :y 61.2)
											(mill-abs :x 87.6 :y 61.2)
											(mill-abs :x 87.6 :y 49.5)
											(mill-abs :x 100.8 :y 49.5)
											(mill-abs :x 100.8 :y 60.0)
											(mill-abs :x 105.8 :y 60)
											(mill-abs :x 105.8 :y 68.4)))
		  
		  
									)))))))))

(defun minicommand-fix-bottom-single ()
  (with-program ("fix-bottom-single")
    (minicommand-fix-bottom)))

(defun minicommand-fix-bottom-drills ()
  (with-named-pass ("drills")
    (with-tool (*mdf-tool-2mm*)
      (with-transform ((mirror-matrix (2dp 0 1)))
				(with-transform ((translation-matrix -90 -0.75))
					(with-transform ((translation-matrix 90 0))
						(with-transform ((rotation-matrix -90))
							(with-transform ((translation-matrix 5 3))
								(drill :x 12.000000 :y 4.000000 :diameter 3.000000 :depth 8)
								(drill :x 97.000000 :y 4.000000 :diameter 3.000000 :depth 8)
								(drill :x 104.000000 :y 74.000000 :diameter 3.000000 :depth 8)
								(drill :x 6.000000 :y 74.000000 :diameter 3.000000 :depth 8))))))))
  (with-named-pass ("fix")
    (with-tool (*pcb-gravier-tool*)
      (with-transform ((mirror-matrix (2dp 0 1)))
				(with-transform ((translation-matrix -90 -0.75))
					(with-transform ((translation-matrix 90 0))
						(with-transform ((rotation-matrix -90))
							(with-transform ((translation-matrix 5 3))
								(goto-abs :x 87.4 :y 78.4 :z *fly-height*)
								(with-tool-down (0.2)
									(mill-abs :x 87.4 :y 78.4)
									(mill-abs :x 83.4 :y 74.0))

								(goto-abs :x 105.8 :y 68.4)
								(with-tool-down (0.2)
									(mill-abs :x 97.2 :y 68.4)
									(mill-abs :x 97.2 :y 61.2)
									(mill-abs :x 87.6 :y 61.2)
									(mill-abs :x 87.6 :y 49.5)
									(mill-abs :x 100.8 :y 49.5)
									(mill-abs :x 100.8 :y 60.0)
									(mill-abs :x 105.8 :y 60)
									(mill-abs :x 105.8 :y 68.4))

								))))))))

  


(defun minicommand-heatsink-fix-board (&optional (start 1))
  (decf start)
  (let ((*fly-height* 10))
    (with-program ("heatsink-fix")
      (when (<= start 0)
				(minicommand-fix))
      
      (when (<= start 1)
				(with-transform ((translation-matrix 0 122))
					(minicommand-fix)))

      (when (<= start 2)
				(with-transform ((translation-matrix 0 244))
					(minicommand-fix)))

      (with-transform ((translation-matrix 105 0))
				(when (<= start 3)
					(minicommand-fix))
	
				(when (<= start 4)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix)))

				(when (<= start 5)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix))))

      (with-transform ((translation-matrix 210 0))
				(when (<= start 6)
					(minicommand-fix))
				(when (<= start 7)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix)))
				(when (<= start 8)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix))))
      

      (with-transform ((translation-matrix 315 0))
				(when (<= start 9)
					(minicommand-fix))
				(when (<= start 10)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix)))
				(when (<= start 11)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix)))))))

(defun minicommand-heatsink-fix-board-bottom (&optional (start 1))
  (decf start)
  (let ((*fly-height* 8))
    (with-program ("heatsink-fix")
      (when (<= start 0)
				(minicommand-fix-bottom-drills)
				(minicommand-fix-bottom))
      
      (when (<= start 1)
				(with-transform ((translation-matrix 0 122))
					(minicommand-fix-bottom-drills)
					(minicommand-fix-bottom)))

      (when (<= start 2)
				(with-transform ((translation-matrix 0 244))
					(minicommand-fix-bottom-drills)
					(minicommand-fix-bottom)))

      (with-transform ((translation-matrix 105 0))
				(when (<= start 3)
					(minicommand-fix-bottom-drills)
					(minicommand-fix-bottom))
	
				(when (<= start 4)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom)))

				(when (<= start 5)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom))))

      (with-transform ((translation-matrix 210 0))
				(when (<= start 6)
					(minicommand-fix-bottom-drills)
					(minicommand-fix-bottom))
				(when (<= start 7)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom)))
				(when (<= start 8)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom))))
      

      (with-transform ((translation-matrix 315 0))
				(when (<= start 9)
					(minicommand-fix-bottom-drills)
					(minicommand-fix-bottom))
				(when (<= start 10)
					(with-transform ((translation-matrix 0 122))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom)))
				(when (<= start 11)
					(with-transform ((translation-matrix 0 244))
						(minicommand-fix-bottom-drills)
						(minicommand-fix-bottom)))))))

(defun minicommand-heatsink-drill-board (&optional (start 1))
  (let ((tool *mdf-tool-2mm*))
    (decf start)
    (with-program ("casing")
      (when (<= start 0)
				(cpu-pcb-drills))

      (when (<= start 1)
				(with-transform ((translation-matrix 0 122))
					(cpu-pcb-drills)))

      (when (<= start 2)
				(with-transform ((translation-matrix 0 244))
					(cpu-pcb-drills)))

      (with-transform ((translation-matrix 105 0))
				(when (<= start 3)
					(cpu-pcb-drills))
	
				(when (<= start 4)
					(with-transform ((translation-matrix 0 122))
						(cpu-pcb-drills)))

				(when (<= start 5)
					(with-transform ((translation-matrix 0 244))
						(cpu-pcb-drills))))

      (with-transform ((translation-matrix 210 0))
				(when (<= start 6)
					(cpu-pcb-drills))
				(when (<= start 7)
					(with-transform ((translation-matrix 0 122))
						(cpu-pcb-drills)))
				(when (<= start 8)
					(with-transform ((translation-matrix 0 244))
						(cpu-pcb-drills))))
      

      (with-transform ((translation-matrix 315 0))
				(when (<= start 9)
					(cpu-pcb-drills))
				(when (<= start 10)
					(with-transform ((translation-matrix 0 122))
						(cpu-pcb-drills)))
				(when (<= start 11)
					(with-transform ((translation-matrix 0 244))
						(cpu-pcb-drills)))))))


(defun test-minicommand-casing ()
  (let ((tool *alu-tool*))
    
    
    (with-program ("casing")
      (minicommand-frontplate *alu-tool*)
      #+nil
      (with-named-pass ("umrandung")
				(goto-abs :x 0 :y 0
									)
				(rectangle-inline 93.5 119 :depth 4)))


		))

(defun test-minicommand-casing-weit (&optional (start 0))
  (let ((tool *alu-tool*))

    (decf start)
    
    
    (with-program ("casing")
      (when (<= start 0)
				(minicommand-frontplate *alu-tool*))

      (when (<= start 1)
				(with-transform ((translation-matrix 0 122))
					(minicommand-frontplate *alu-tool*)))

      (when (<= start 2)
				(with-transform ((translation-matrix 0 244))
					(minicommand-frontplate *alu-tool*)))

      (with-transform ((translation-matrix 105 0))
				(when (<= start 3)
					(minicommand-frontplate *alu-tool*))
	
				(when (<= start 4)
					(with-transform ((translation-matrix 0 122))
						(minicommand-frontplate *alu-tool*)))

				(when (<= start 5)
					(with-transform ((translation-matrix 0 244))
						(minicommand-frontplate *alu-tool*))))

      (with-transform ((translation-matrix 210 0))
				(when (<= start 6)
					(minicommand-frontplate *alu-tool*))
				(when (<= start 7)
					(with-transform ((translation-matrix 0 122))
						(minicommand-frontplate *alu-tool*)))
				(when (<= start 8)
					(with-transform ((translation-matrix 0 244))
						(minicommand-frontplate *alu-tool*))))
      

      (with-transform ((translation-matrix 315 0))
				(when (<= start 9)
					(minicommand-frontplate *alu-tool*))
				(when (<= start 10)
					(with-transform ((translation-matrix 0 122))
						(minicommand-frontplate *alu-tool*)))
				(when (<= start 11)
					(with-transform ((translation-matrix 0 244))
						(minicommand-frontplate *alu-tool*))))
			)))


(defun test-minicommand-casing-2 ()
  (with-program ("casing2")
    (minicommand-frontplate *alu-tool*)
    (with-transform ((translation-matrix 0 122))
      (minicommand-frontplate *alu-tool*))))

(defun test-minicommand-casing-3 ()
  (with-program ("casing2")
    (minicommand-frontplate *alu-tool*)
    (with-transform ((translation-matrix 0 122))
      (minicommand-frontplate *alu-tool*))
    (with-transform ((translation-matrix 0 244))
      (minicommand-frontplate *alu-tool*))))


(defun test-rotation ()
  (with-program ("test")
    (with-tool ((make-instance 'tool :diameter 2 :depth 4 :number 6 :feed-xy 600 :feed-z 240))
      (with-transform ((rotation-matrix 90))
				;;	(with-transform ((translation-matrix 100 100))
				;;	(drill :x 100 :y 100 :diameter 20)
				(goto-abs :x 100 :y 100)
				(rectangle-inline 20 20)

				))))

(defun minicommand-fix-innen ()
  (with-program ("minicommand-fix")
    (with-named-pass ("fix")
      (with-tool (*grob-tool*)
				(spindle-on)
				(goto-abs :x -0.65 :z 2 :y 111.5)
				(loop for i from 2.5 upto 10 by 5
					 do (mill-abs :z (- i))
					 (mill-abs :y 187.5)
					 (format t "mill to 187 at ~A~%" (- i))
					 (mill-abs :z (- (+ i 2.5)))
					 (mill-abs :y 111.5)
					 (format t "mill to 111.5 at ~A~%" (- (+ i 2.5)))
					 )
				(mill-abs :x -0.45)
				(loop for i from 12.5 upto 22.5 by 5
					 do (mill-abs :z (- i))
					 (mill-abs :y 187.5)
					 (format t "mill2 to 187 at ~A~%" (- i))
					 (mill-abs :z (- (+ i 2.5)))
					 (mill-abs :y 111.5)
					 (format t "mill2 to 111.5 at ~A~%" (- (+ i 2.5)))
					 )
	
				(mill-abs :z 2)))))

(defun minicommand-casing-side-top-hammond-first ()
  (let ((tool *alu-tool*)
				(*frontplate-depth* 3.3))
    (with-program ("casing")
      (with-named-pass ("frontplate")
				(with-tool (tool)
					(goto-abs :x 0 :y 0)
					(goto-abs :z *fly-height*)))
      
      
			(with-named-pass ("mill")
				(with-tool (*alu-tool*)
					(with-transform ((translation-matrix 2.1 8.5))
						(let ((*eagle-drills-p* nil)
									(*frontplate-top* nil)
									(*frontplate-side* t))
							(load-file "/Users/manuel/siff-svn/ruinwesen/eagle/midicommand/minicommand.lisp"))))))))

