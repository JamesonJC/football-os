#from django.db import models
from django.contrib.auth.models import AbstractUser

# User model.

class User(AbstractUser):
    """
    Custom User model.

    Future extension:
    - Favourate fottbal teams
    - Community memberships
    - User preferences
    - Notification preferences
    
    """
    pass
