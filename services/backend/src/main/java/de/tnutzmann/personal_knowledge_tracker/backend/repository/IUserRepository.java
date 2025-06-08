package de.tnutzmann.personal_knowledge_tracker.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;

import de.tnutzmann.personal_knowledge_tracker.backend.model.User;

@Repository
public interface IUserRepository extends JpaRepository<User, UUID>{
  
}
