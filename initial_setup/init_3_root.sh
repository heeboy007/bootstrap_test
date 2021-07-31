#!/bin/bash
a2dissite 000-default
a2ensite blog
service apache2 reload