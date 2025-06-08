package de.tnutzmann.personal_knowledge_tracker.backend.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import de.tnutzmann.personal_knowledge_tracker.backend.model.User;
import de.tnutzmann.personal_knowledge_tracker.backend.repository.IUserRepository;

@Service
public class UserService {
  
  @Autowired
  IUserRepository userRepository;

  public List<User> getAllUsers() {
    return userRepository.findAll();
  }
}
