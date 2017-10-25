Name:           ros-kinetic-roslisp
Version:        1.9.21
Release:        0
Summary:        Lisp client library for ROS, the Robot Operating System
Group:          Development/Libraries
License:        BSD
URL:            http://ros.org/wiki/roslisp
Source0:        %{name}-%{version}.tar.gz
Source1001:     %{name}.manifest
BuildRequires:  ros-kinetic-catkin
Requires:       ros-kinetic-roslang
Requires:       ros-kinetic-rospack
Requires:       ros-kinetic-rosgraph-msgs
Requires:       ros-kinetic-std-srvs

# Workaround to resolve the circular dependency in sbcl package
# Requires:       sbcl

%description
Lisp client library for ROS, the Robot Operating System

%prep
%setup -q
cp %{SOURCE1001} .

%build
%{__ros_setup}
%{__ros_build}

%install
%{__ros_setup}
%{__ros_install}

%files -f build/install_manifest.txt
%manifest %{name}.manifest
%defattr(-,root,root)
