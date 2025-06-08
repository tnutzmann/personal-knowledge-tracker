package de.tnutzmann.personal_knowledge_tracker.backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import de.tnutzmann.personal_knowledge_tracker.backend.model.User;
import de.tnutzmann.personal_knowledge_tracker.backend.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping("api/users")
public class UserController {
  
  @Autowired
  UserService userService;

  @GetMapping
  public List<User> getAllUsers() {
    return userService.getAllUsers();
  }
}
