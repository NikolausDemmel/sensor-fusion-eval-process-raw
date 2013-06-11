
.PHONY: all clean plot-imu

all: richimage.bag imu.bag plot-imu

clean:
	rm richimage.bag imu.bag *.log *.pdf || true

richimage.bag: recorded.bag
	$(ROSLAUNCH_OPTIRUN) rosrun vps_bag_tools bag_richimage -i recorded.bag -o richimage.bag -s ../c.xml | tee richimage.log
	chmod a-w richimage.bag # protect from accidental deletion
	chmod a-w richimage.log # protect from accidental deletion

imu.bag: recorded.bag
	rosrun uvm_handheld_evaluation rosbag_merge.py imu.bag recorded.bag -t "*imu*/data*" -v | tee imu.log

plot-imu: angvel.pdf linacc.pdf

angvel.% linacc.%: imu.bag 
	rosrun uvm_handheld_evaluation rosbag_plot_imu.py imu.bag -v -t /xsens_imu/imu/data
